# Bandiera

Bandiera is a simple, stand-alone feature flagging service that is not tied to
any existing web framework or language as all communication is via a simple
REST API.  It also has a simple web interface for setting up and configuring
flags.

### Setup

1. Configure your authorization access to Google Cloud by running:

    ```bash
    make gcloud-auth
    ```

1. Run the setup script to get everything working:

    ```bash
    make setup
    ```

### How to run the app

1. Run the rails app with all dependent services as Docker containers: MySQL (Database), Elastisearch, and Minio (File Storage).

    ```bash
    docker-compose up app

    # or to run in the background
    docker-compose up -d app
    ```

    You can now visit the web interface at [http://0.0.0.0:5050](http://0.0.0.0:5050)
