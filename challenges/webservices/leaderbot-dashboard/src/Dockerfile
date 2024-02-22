FROM python:alpine3.19

WORKDIR /usr/src/app

RUN apk add gcc musl-dev libmemcached-dev zlib-dev memcached

RUN pip install flask pylibmc cachelib flask_session python-jose authlib

COPY cacheapp.py .
RUN chmod 665 ./cacheapp.py
COPY flag.txt .
RUN chmod 664 ./flag.txt
COPY templates ./templates

RUN adduser -D ctf 

RUN chown -R root:ctf $(pwd) && \
    chmod -R 650 $(pwd) && \
    chown -R root:ctf /home/ctf/ && \
    chmod -R 650 /home/ctf

USER ctf

EXPOSE 8000

CMD memcached -u root -l 0.0.0.0 -p 11211 -d && python cacheapp.py
