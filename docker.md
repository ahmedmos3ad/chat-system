# Running the App with Docker Compose

1. Make sure you have Docker installed on your system.

2. Clone the repository

    ```bash
    git clone git@github.com:ahmedmos3ad/chat-system.git
    ```

3. Navigate to the project directory.

    ```bash
    cd chat-system
    ```

3. Create a `.env` file in the root directory of the project and add the following environment variables.

    ```bash
    RAILS_ENV=development
    DOCKER_ENV=dev # This is used to determine which Dockerfile is used, delete this if you wanna use the production Dockerfile
    RAILS_MASTER_KEY=your_rails_master_key # This is used to decrypt the credentials.yml.enc file and must be provided the value usually resides in config/master.key unless you have credentials defined for specific environments, if that is the case look for development.key and production.key and pass the appropriate value depending on the RAILS_ENV and which dockerfile you are using.
    DATABASE_URL=mysql://mysql:password@mysql:3307/chat_system_development # This is used to connect to the database, the format is mysql://username:password@host:port/database_name
    MYSQL_ROOT_USER=mysql
    MYSQL_DATABASE=chat_system_development
    MYSQL_PORT=3307 #should match the port mapping in the docker-compose file
    MYSQL_USER=mysql
    MYSQL_PASSWORD=password
    MYSQL_HOST=mysql
    REDIS_URL=redis://redis:6379/0
    ELASTICSEARCH_URL=http://elasticsearch:9200
    ```

4. Build and start the containers using Docker Compose.

    ```bash
    docker-compose up --watch
    ```
