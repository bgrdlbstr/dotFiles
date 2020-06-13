#!/bin/sh

# Git config
if [ ! -z "$GIT_USER_NAME" ] && [ ! -z "$GIT_USER_EMAIL" ]; then
    git config --global user.name "$GIT_USER_NAME"
    git config --global user.email "$GIT_USER_EMAIL"
fi

USER_ID=${HOST_USER_ID:-9001}
GROUP_ID=${HOST_GROUP_ID:-9001}
# Change david uid to host users uid
if [ ! -z "$USER_ID" ] && [ "$(id -u david)" != "$USER_ID" ]; then
    # Create the user group if it does not exist
    groupadd --non-unique -g "$GROUP_ID" group    # Set the user's uid and gid
    usermod --non-unique --uid "$USER_ID" --gid "$GROUP_ID" david
fi

# Setting permissions on /home/me
chown -R david: /home/david 
# Setting permissions on docker.sock
chown david: /var/run/docker.sock

exec /sbin/su-exec david tmux -u -2 "$@"

