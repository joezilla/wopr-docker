#!/bin/bash

docker build --pull -t joezilla/pocketmine:latest -f 3.11/Dockerfile . && \
docker push joezilla/pocketmine:latest
