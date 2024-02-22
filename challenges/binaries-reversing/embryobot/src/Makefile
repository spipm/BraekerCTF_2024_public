build:
	nasm -f bin -o embryobot embryobot.asm 
	chmod +x ./embryobot

deb:
	objdump -b binary --start-address=$(i) -M intel -D -m i386 ./embryobot
