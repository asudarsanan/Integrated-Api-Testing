FROM node:10-alpine
LABEL maintainer="aasishsudarsanan"
# Set environment variables
ENV LC_ALL="en_US.UTF-8" LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" ALPINE_NODE_REPO="oznu/alpine-node"
RUN  npm install --global newman@4.6.1;
RUN  npm install --global newman-reporter-html@1.0.5
# Set workdir to /etc/newman
WORKDIR /etc/newman
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
RUN newman -v 
ENTRYPOINT ["/entrypoint.sh"]