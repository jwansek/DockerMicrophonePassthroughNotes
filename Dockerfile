FROM ubuntu:22.04
MAINTAINER Eden Attenborough "eda@e.email"
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update -y
RUN apt-get install -y alsa-base alsa-utils usbutils