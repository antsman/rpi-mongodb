FROM resin/armv7hf-debian:jessie
# FROM resin/raspberry-pi2-debian

# User, home (app) and data folders
#ENV USER baseuser
ENV DATA /data
# ENV HOME /usr/src/$USER

RUN apt-get update && \
    apt-get upgrade && \
    apt-get install mongodb && \
#   apk-get install bash && \
    rm -rf /var/lib/apt/lists/*

# Prepare data folder
RUN mkdir $DATA

WORKDIR $DATA

# Add $USER user so we aren't running as root.
# RUN adduser --home $DATA --no-create-home -gecos '' --disabled-password $USER && \
#   chown -R $USER:$USER $HOME && \
#    chown -R $USER:$USER $DATA

#USER $USER

CMD ["/bin/bash"]
