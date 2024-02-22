FROM ubuntu:latest as builder

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install -y g++ \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY ./e.cpp .
RUN g++ e.cpp -o ./e


FROM ubuntu:latest

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install -y socat \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m ctf
WORKDIR /home/ctf

COPY --chown=ctf:ctf --from=builder /app/e ./e

EXPOSE 2000

ENTRYPOINT socat TCP-LISTEN:2000,reuseaddr,fork,user=ctf,group=ctf EXEC:'./e'