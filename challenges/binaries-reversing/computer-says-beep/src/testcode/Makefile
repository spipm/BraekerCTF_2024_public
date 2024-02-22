
# get bytecode:
# objcopy -O binary -j .text ./testimport.exe /dev/stdout | hexdump -v -e '/1 "0x%02x, "'
# objdump -d ./testimport.exe
#  > manually filter out bytecode for function

build:
	# needs to be position independable for moving to asm
	i686-w64-mingw32-g++ -fPIC -O2 testimport.cpp -o testimport.exe -nostdlib -mwindows -Wl,--entry=_WinMain@16
	i686-w64-mingw32-g++  -s -static-libstdc++ -static-libgcc hash.c -o hash.exe