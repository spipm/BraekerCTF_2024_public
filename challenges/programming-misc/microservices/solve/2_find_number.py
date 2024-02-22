import requests
from time import sleep

maxValue = 319


for port in range(1000,1000+maxValue+1):
	url = "http://braekerctf.butsers.nl:%s/guess?guess=" % port

	entry = port-1000

	guess = maxValue/2
	low = 0
	high = maxValue

	while low <= high:
		print()
		

		mid = (high + low) // 2

		guess = mid
		print("guess = %s" % guess)

		try:
			res = requests.get(url + str(guess), timeout=3)
		except:
			res = requests.get(url + str(guess))
		sleep(0.08)

		f=open('pass.txt','r')
		d=f.read()
		f.close()

		# If x is greater, ignore left half
		if 'low' in d:
			print("too low")
			low = mid + 1

		# If x is smaller, ignore right half
		elif 'high' in d:
			print("too high")
			high = mid - 1

		else:
			print("Did we get it?: %s" % d)
			break

