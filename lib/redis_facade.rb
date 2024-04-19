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
          logger.info("RedisClient::Releasing lock for #{key}")
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
    lock_key = "lock:#{set_key}"
    
    @redis.with do |conn|
      locked = @redis.setnx(lock_key, 1)
      if locked
        logger.info("RedisClient::Aquired lock for #{lock_key} successfully")
        begin
          logger.info("RedisClient::Adding entry #{entry} to set: #{set_key}")
          @redis.sadd(set_key, entry)
        ensure
          logger.info("RedisClient::Releasing lock #{lock_key}")
          @redis.del(lock_key)
        end
      else
        logger.info("RedisClient::Failed to acquire lock for #{set_key}, retrying in 1 second")
        sleep(1)
        add_entry_to_set(entry, set_key) # Retry recursively
      end
    end
  end

end