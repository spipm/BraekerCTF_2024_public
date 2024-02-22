from scapy.all import *
from random import randint
load_layer("http")
import random
import json

pickMapping = {}

maxValue = 320


def packet_callback(pkt):

    # User packet variables
    ip = pkt[IP]
    tcp = pkt[TCP]
    payload = str(bytes(tcp.payload))

    entry = tcp.sport-1000

    if tcp.seq == 7331:
        f=open('pass.txt','w')
        f.write('low')
        f.close()

    if tcp.seq == 7332:
        f=open('pass.txt','w')
        f.write('high')
        f.close()

    if tcp.seq >= 7333:
        raw_layer = tcp.payload
        payload_bytes = raw_layer.original
        payload = payload_bytes.decode("utf-8", errors="ignore")

        start = payload.find("guess = ")+len("guess = ")
        end = payload.find("\r", start+1)

        guess = payload[start:end]
        bitvalue = tcp.seq - (7333)
        
        pickMapping[int(entry)] = (int(guess), bitvalue)

        print("guess = %s, bitvalue = %s, entry = %s" % (guess, bitvalue, entry))

        # print("Flags = %s, seq = %s, port = %s" % (tcp.flags, tcp.seq, tcp.sport))
        # print("Bitvalue for pos %s is %s" % (pos, bitvalue))

        f=open('got_data.txt','w')
        f.write(json.dumps(pickMapping))
        f.close()

        f=open('pass.txt','w')
        f.write('got it')
        f.close()


# Filter packets for required ports
def packet_filter(pkt):
    return (TCP in pkt and
            pkt[TCP].sport >= 1000 and pkt[TCP].sport <= 1511)


# Spin up hundreds of webservices just like in the cloud
sniff(filter="tcp", prn=packet_callback, lfilter=packet_filter)
