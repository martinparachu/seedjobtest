FROM mcr.microsoft.com/dotnet/core/aspnet:3.1

RUN apt-get update -y
RUN apt-get install -y libyaml-dev libpython3-dev python3-pip groff
RUN pip3 install --upgrade pip
RUN pip3 install awscli
RUN apt-get update \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash \
    && apt-get -y install build-essential nodejs
