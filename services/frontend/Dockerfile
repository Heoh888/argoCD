FROM nginx:1.27-alpine

ARG APP_VERSION=0.0.0
ENV APP_VERSION=${APP_VERSION}

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY html/ /usr/share/nginx/html/
