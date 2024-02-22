NS=nasm
OBJ=binary_shrink

.PHONY: all clean

all: $(OBJ)

binary_shrink: binary_shrink.asm
	$(NS) -f bin -o ./output/binary_shrink binary_shrink.asm
	chmod +x ./output/binary_shrink

test:
	objdump -b binary --start-address=$(i) -M intel -D -m i386:x86-64 ./output/binary_shrink

clean:
	rm -f $(OBJ)
