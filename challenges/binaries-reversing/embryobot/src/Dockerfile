FROM alpine:latest

RUN adduser -D ctf
RUN chmod 500 /home/ctf

WORKDIR /home/ctf

COPY embryobot .
RUN chmod 665 ./embryobot

COPY flag.txt .
RUN chmod 664 ./flag.txt

EXPOSE 2000

user ctf

ENTRYPOINT socat TCP-LISTEN:2000,reuseaddr,fork,user=ctf,group=ctf EXEC:'./embryobot'