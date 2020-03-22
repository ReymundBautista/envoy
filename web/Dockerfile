FROM tiangolo/uwsgi-nginx-flask:python3.6-alpine3.7
# URL under which static (not modified by Python) files will be requested
# They will be served by Nginx directly, without being handled by uWSGI
ENV STATIC_URL /static
# Absolute path in where the static files wil be
ENV STATIC_PATH /var/www/flask/static
RUN apk --update add bash vim
RUN mkdir -p /var/www/flask/static
VOLUME /app
ADD flask /app
ADD requirements.txt /var/www/requirements.txt
RUN pip install -r /var/www/requirements.txt
