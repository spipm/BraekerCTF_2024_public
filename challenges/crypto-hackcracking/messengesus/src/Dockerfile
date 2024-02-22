FROM ubuntu:latest as builder

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install -y gcc \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY ./messengesus.c .
RUN gcc messengesus.c -o ./messengesus


FROM ubuntu:latest

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install -y socat \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m ctf
WORKDIR /home/ctf

COPY --chown=ctf:ctf --from=builder /app/messengesus ./messengesus

EXPOSE 2000

ENTRYPOINT socat TCP-LISTEN:2000,reuseaddr,fork,user=ctf,group=ctf EXEC:'./messengesus'