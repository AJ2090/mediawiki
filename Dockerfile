FROM php:7.2-apache

RUN apt-get update \
    apt-get install php7.2-mysql php7.2-gd php7.2-xml php7.2-json php7.2-common php7.2-mbstring php7.2-opcache


