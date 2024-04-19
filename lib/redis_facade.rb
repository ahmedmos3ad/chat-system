# frozen_string_literal: true

class RedisFacade
  include Singleton

  attr_reader :redis

  APPLICATIONS_WITH_NEW_CHAT_ROOMS_KEY = 'applications_with_new_chat_rooms'
  CHAT_ROOMS_WITH_NEW_MESSAGES_KEY = 'chat_rooms_with_new_messages'

  def initialize
    # use ConnectionPool as per docs to manage Redis connection to share across threads
    @redis ||= ConnectionPool::Wrapper.new do
      Redis.new(url: ENV['REDIS_URL'])
    end
  end

  def incr(key)
    logger.info("RedisClient::Incrementing key: #{key}")
    @redis.with do |conn|
      conn.incr(key) # incr is an atomic operation in Redis and is thread-safe by default so no race condition
    end
  end

  def fetch_and_clear_set_for_key(key)
    @redis.del("lock:#{key}")
    logger.info("RedisClient::Fetching and clearing #{key}")
    @redis.with do |conn|
      logger.info("RedisClient::Acquiring lock for #{key}")
      locked = @redis.setnx("lock:#{key}", 1)
      if locked
        begin
          set = @redis.smembers(key)
          @redis.del(key)
          return set
        ensure
          @redis.del("lock:#{key}")
        end
      else
        logger.info("RedisClient::Failed to acquire lock for #{key}, retrying in 1 second")
        sleep(1)
        fetch_and_clear_applications_with_new_chat_rooms_set
      end
    end
  end

  def add_entry_to_set(entry, set_key)
    logger.info("RedisClient::Adding entry #{entry} to set: #{set_key}")
    @redis.with do |conn|
      @redis.sadd(set_key, entry)
    end
  end

end