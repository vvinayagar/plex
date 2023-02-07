# Use the official Ubuntu 22.04 base image
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    lsb-release \
    adduser \
    gosu
# Add the package repository for Plex
RUN apt-get update && apt-get install -y curl
RUN curl https://downloads.plex.tv/plex-keys/PlexSign.key | apt-key add -
RUN echo "deb https://downloads.plex.tv/repo/deb public main" | tee /etc/apt/sources.list.d/plexmediaserver.list

# Install Plex Media Server
RUN apt-get update && apt-get install -y plexmediaserver

# Create the "plex" user and group
RUN groupadd -r plex && useradd -r -g plex plex

# Change ownership of the Plex installation directory to the "plex" user and group
RUN chown -R plex:plex /usr/lib/plexmediaserver

# set the home directory for the plex user
ENV HOME /home/plex
RUN mkdir $HOME && chown plex:plex $HOME

COPY ./plex.sh /home/plex/plex.sh

RUN chmod +x /home/plex/plex.sh
# Start the Plex Media Server as the "plex" user

RUN chown plex:plex /home/plex/plex.sh
RUN chmod +x /home/plex/plex.sh

USER plex
WORKDIR /usr/lib/plexmediaserver

# Expose the default Plex Media Server port
EXPOSE 32400
#CMD ["gosu", "plex", "/home/plex/plex.sh"]
#CMD ["su", "plex", "-c", "/home/plex/plex.sh"]
#RUN ["/usr/lib/plexmediaserver/lib/plexmediaserver.init", "start"]
#RUN ["/usr/lib/plexmediaserver/lib/plexmediaserver.init", "status"]
#CMD ["/bin/sh", "-c", "/usr/lib/plexmediaserver/lib/plexmediaserver.service"]
CMD ["/bin/sh", "-c", "/home/plex/plex.sh"]
#CMD ["/usr/lib/plexmediaserver/lib/plexmediaserver.init", "start"]