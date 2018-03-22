suso:		suso.o
		ld -melf_i386_fbsd -o suso suso.o
		-strip suso
suso.o:	suso.asm
		nasm -f elf -o suso.o suso.asm	
clean:		
		-rm suso.o suso

