NS=nasm
OBJ=fetusbot

.PHONY: all clean

all: $(OBJ)

fetusbot: fetusbot.asm
	$(NS) -f bin -o fetusbot fetusbot.asm
	chmod +x fetusbot

clean:
	rm -f $(OBJ)
