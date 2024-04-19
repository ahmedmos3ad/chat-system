# Chat System

## Running the App with Docker Compose

1. Make sure you have Docker installed on your system.

2. Clone the repository

    ```bash
    git clone git@github.com:ahmedmos3ad/chat-system.git
    ```

3. Navigate to the project directory.

    ```bash
    cd chat-system
    ```

4. Build and start the containers using Docker Compose.

    ```bash
    docker-compose up --build
    ```

5. Once the containers are up and running, you can access the app at `http://localhost:3000` in your web browser.


## Database Schema

The database schema for this application consists of the following tables:

### Applications

| Field         | Type      | Constraints          | Description                                         |
|---------------|-----------|----------------------|-----------------------------------------------------|
| id            | bigint    | Primary Key          | Auto-generated unique identifier for the application|
| token         | string    | Unique, Not Null     | Unique identifier for the application              |
| name          | string    | Not Null             | Name of the application                            |
| chats_count   | integer   | Default: 0, Not Null | Number of chats associated with the application    |
| created_at    | datetime  | Not Null             | Timestamp indicating when the record was created   |
| updated_at    | datetime  | Not Null             | Timestamp indicating when the record was last updated|

- **Indexes:**
  - `index_applications_on_token`: Unique index on the `token` field.

### Chat Rooms

| Field           | Type      | Constraints              | Description                                           |
|-----------------|-----------|--------------------------|-------------------------------------------------------|
| id              | bigint    | Primary Key              | Auto-generated unique identifier for the chat room    |
| application_id  | bigint    | Foreign Key, Not Null    | Reference to the parent application                   |
| number          | integer   | Not Null                 | Unique identifier for the chat room within the app    |
| messages_count  | integer   | Default: 0, Not Null     | Number of messages associated with the chat room     |
| created_at      | datetime  | Not Null                 | Timestamp indicating when the record was created     |
| updated_at      | datetime  | Not Null                 | Timestamp indicating when the record was last updated|

- **Indexes:**
  - `index_chat_rooms_on_application_id_and_number`: Unique index on `application_id` and `number` fields.
  - `index_chat_rooms_on_application_id`: Index on `application_id` field.

### Chat Messages

| Field         | Type      | Constraints              | Description                                       |
|---------------|-----------|--------------------------|---------------------------------------------------|
| id            | bigint    | Primary Key              | Auto-generated unique identifier for the message |
| chat_room_id  | bigint    | Foreign Key, Not Null    | Reference to the parent chat room                 |
| number        | integer   | Not Null                 | Unique identifier for the message within the chat |
| body          | text      | Not Null                 | Content of the message                            |
| created_at    | datetime  | Not Null                 | Timestamp indicating when the record was created |
| updated_at    | datetime  | Not Null                 | Timestamp indicating when the record was last updated|

- **Indexes:**
  - `index_chat_messages_on_chat_room_id_and_number`: Unique index on `chat_room_id` and `number` fields.
  - `index_chat_messages_on_chat_room_id`: Index on `chat_room_id` field.

### Relationships

- **Applications to Chat Rooms:** One-to-Many relationship. An application can have multiple chat rooms.
- **Chat Rooms to Chat Messages:** One-to-Many relationship. A chat room can have multiple chat messages.

## Endpoints

### Applications CRUD

#### Creating an application

request

 ```bash
  curl --location '127.0.0.1:3000/api/v1/applications' \
  --header 'Content-Type: application/json' \
  --data '{
      "application":{
          "name": "some app name"
      }
  }'
 ```

response

```json
  {
    "status": 201,
    "data": {
        "application": {
            "token": "7fbb9574-d58f-4a06-aaa5-9b0bbcd8b685",
            "name": "some app name",
            "created_at": "2024-04-19T16:39:46.274Z",
            "updated_at": "2024-04-19T16:39:46.274Z"
        }
    }
}
```

### Updating an application by its token

request

```bash
curl --location --request PUT '127.0.0.1:3000/api/v1/applications/d684aa5f-c3e7-4f84-ac26-22bbe7afc581' \
--header 'Content-Type: application/json' \
--data '{
    "application":{
        "name": "some updated app name"
    }
}'
```

response

```json
{
    "status": 200,
    "data": {
        "application": {
            "token": "52b0b611-09f9-4623-aa87-27a27d26f7a3",
            "name": "some updated app name"
        }
    }
}
```

### Listing all applications

request

```bash
curl --location '127.0.0.1:3000/api/v1/applications?page_number=1&page_size=2'
```

response

```json
{
    "status": 200,
    "data": {
        "applications": [
            {
                "token": "5620f0c0-f5d5-4102-8d11-f08370a330a3",
                "name": "some updated app name",
                "created_at": "2024-04-16T06:46:28.665Z",
                "updated_at": "2024-04-16T06:46:28.665Z"
            },
            {
                "token": "4372bf6a-bcc6-42de-bafb-f4b14f078190",
                "name": "some app name",
                "created_at": "2024-04-16T06:48:32.697Z",
                "updated_at": "2024-04-16T06:48:32.697Z"
            }
        ],
        "pagination_info": {
            "total_count": 17,
            "page_number": 1,
            "page_size": 2
        }
    }
}
```

### Showing an application by its token

request

```bash
curl --location '127.0.0.1:3000/api/v1/applications/d684aa5f-c3e7-4f84-ac26-22bbe7afc581'
```
response

```json
{
    "status": 200,
    "data": {
        "application": {
            "token": "d684aa5f-c3e7-4f84-ac26-22bbe7afc581",
            "name": "some app name"
        }
    }
}
```

### Deleting an application by its token

request

```bash
curl --location --request DELETE '127.0.0.1:3000/api/v1/applications/d684aa5f-c3e7-4f84-ac26-22bbe7afc581' \
--header 'Content-Type: application/json'
```

returns a 204 with no body on success


## Application Chat Endpoints

### Creating an application chat

request

```bash
curl --location --request POST '127.0.0.1:3000/api/v1/applications/7fbb9574-d58f-4a06-aaa5-9b0bbcd8b685/chats'
```

response

```json
{
    "status": 202,
    "data": {
        "chat_room": {
            "number": 44
        }
    }
}
```

### Listing application chats

request

```bash
curl --location '127.0.0.1:3000/api/v1/applications/cfe8bd8f-d3f2-487e-a650-0d4c2e796b24/chats?page_number=1&page_size=20'
```

response

```json
{
    "status": 200,
    "data": {
        "chat_rooms": [
            {
                "number": 1,
                "messages_count": 2,
                "created_at": "2024-04-19T16:51:53.194Z",
                "updated_at": "2024-04-19T16:51:53.194Z"
            }
        ],
        "pagination_info": {
            "total_count": 1,
            "page_number": 1,
            "page_size": 20
        }
    }
}
```

### Show certain application chat by its number and app token

request

```bash
curl --location '127.0.0.1:3000/api/v1/applications/cfe8bd8f-d3f2-487e-a650-0d4c2e796b24/chats/9'
```

response

```json
{
    "status": 200,
    "data": {
        "chat_room": {
            "number": 1,
            "messages_count": 11,
            "created_at": "2024-04-19T16:51:53.194Z",
            "updated_at": "2024-04-19T16:51:53.194Z"
        }
    }
}
```

## Application Chat Messages Endpoints

### Create a Chat Message using application's token and chat's number

request

```bash
curl --location '127.0.0.1:3000/api/v1/applications/cfe8bd8f-d3f2-487e-a650-0d4c2e796b24/chats/1/messages' \
--header 'Content-Type: application/json' \
--data '{
    "message": {
        "body": "what a great day"
    }
}'
```

response
```json
{
    "status": 202,
    "data": {
        "chat_message": {
            "number": 1,
            "body": "what a great day"
        }
    }
}
```

### Listing a Chat messages using application's token and chat's number

request

```bash
curl --location --request GET '127.0.0.1:3000/api/v1/applications/cfe8bd8f-d3f2-487e-a650-0d4c2e796b24/chats/1/messages?page_number=1&page_size=10' \
--header 'Content-Type: application/json'
```

response

```json
{
    "status": 200,
    "data": {
        "chat_messages": [
            {
                "number": 1,
                "body": "what a great day",
                "created_at": "2024-04-19T17:15:42.301Z",
                "updated_at": "2024-04-19T17:15:42.301Z"
            },
            {
                "number": 2,
                "body": "are you still reading?",
                "created_at": "2024-04-19T18:21:25.835Z",
                "updated_at": "2024-04-19T18:21:25.835Z"
            }
        ],
        "pagination_info": {
            "total_count": 2,
            "page_number": 1,
            "page_size": 10
        }
    }
}
```

### Search Chat messages body partially

request
```bash
curl --location '127.0.0.1:3000/api/v1/applications/cfe8bd8f-d3f2-487e-a650-0d4c2e796b24/chats/1/messages/search?page_number=1&page_size=10&keyword=at%20day'
```

response
```json
{
    "status": 200,
    "data": {
        "chat_messages": [
            {
                "number": 2,
                "body": "what a great day",
                "created_at": "2024-04-19T16:58:54.686Z",
                "updated_at": "2024-04-19T16:58:54.686Z"
            }
        ],
        "pagination_info": {
            "total_count": 1,
            "page_number": 1,
            "page_size": 10
        }
    }
}
```

Feel free to import the postman collection provided in the repo for testing/checking examples.

