[中文版](https://github.com/Jiacheng-z/quick-development-environment/blob/master/nginx%2Bmemcache%2Bredis/README_ZH.md)
# Personal development environment.

## Features
1. Nginx, Redis, Memcache, docker environment.
2. Docker compose support.
3. Alfred workflow support.

## Usage
**Note: Remeber to change config file in config_example directory, or change docker-compose.yml.**

### 1. Native docker compose.
### 2. Use Alfred workflow.
1. Import manager_base.alfredworkflow.
2. Change docker-compose.yml path in workflow action node.
    - Run Script node.
    - Terminal Command node.

Command:
- `dc up -d`: Start environment in background.
- `dc up`: Start environment with terminal command. Or show background running log.
- `dc down`: Stop and Remove environment.

## Depend on
- docker
- docker-compose (suggest: support version 3)
