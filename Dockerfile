# Base image
FROM alpine:latest

LABEL "com.github.actions.name"="Upload Ghost theme"
LABEL "com.github.actions.description"="Used to upload a Ghost theme"
LABEL "com.github.actions.icon"="umbrella"
LABEL "com.github.actions.color"="blue"

# installes required packages for our script
RUN apk add --no-cache \
  bash \
  ca-certificates \
  curl \
  jq

# Copies your code file  repository to the filesystem
COPY entrypoint.sh /entrypoint.sh

# change permission to execute the script and
RUN chmod +x /entrypoint.sh

# file to execute when the docker container starts up
ENTRYPOINT ["/entrypoint.sh"]