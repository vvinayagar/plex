
FROM ubuntu:22.04

# Update the package list and install required dependencies
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    lsb-release

# Add the Plex repository key
RUN wget https://downloads.plex.tv/plex-keys/PlexSign.key && \
    apt-key add PlexSign.key

# Add the Plex repository
RUN echo "deb https://downloads.plex.tv/repo/deb public main" | \
    tee /etc/apt/sources.list.d/plexmediaserver.list

# Update the package list and install Plex Media Server
RUN apt-get update && apt-get install -y plexmediaserver net-tools

# Set the working directory to /app
WORKDIR /app

# Copy the local directory to the container
COPY . .

# Set the environment variable for the time zone to Malaysia
ENV TZ=Asia/Kuala_Lumpur

# Expose the default Plex port
EXPOSE 32400

RUN ifconfig
#CMD ["/usr/sbin/plexmediaserver"]
CMD ["/bin/sh", "-c", "ifconfig"]