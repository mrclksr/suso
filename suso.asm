;
;  Copyright (c) 2006 Marcel Kaiser <mk@nic-nac-project.org>
;  All rights reserved.
; 
;  Redistribution and use in source and binary forms, with or without
;  modification, are permitted provided that the following conditions
;  are met:
;  1. Redistributions of source code must retain the above copyright
;     notice, this list of conditions and the following disclaimer.
;  2. Redistributions in binary form must reproduce the above copyright
;     notice, this list of conditions and the following disclaimer in the
;     documentation and/or other materials provided with the distribution.
;  3. The name of the author may not be used to endorse or promote products
;     derived from this software without specific prior written permission.
; 
;  THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
;  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;  ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
;  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
;  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
;  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
;  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
;  OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
;  SUCH DAMAGE.
; 
;  
; 

BITS 32

CPU 586

%include "sysf.inc"

%define TAB	9
%define LF	0xa
%define SUDO_SZ	81
%define BUF_SZ	1024

;+++++++++++++++++++++++++++++++++++++++++++
;+   		search_in_col              +
;+-----------------------------------------+
;+args: edi = addr(sudoku)		   + 
;+	dl  = number		           + 
;+	al  = col			   +	
;+ret : > 0 if found else 0   	           +
;+++++++++++++++++++++++++++++++++++++++++++
%macro search_in_col 0			  ;+	
		push edi		  ;+			
		push ecx		  ;+
		mov cl, 9		  ;+
.go_on0:	cmp byte[edi+eax], dl	  ;+
		je .found0		  ;+
		add edi, 9		  ;+	next row
		dec cl			  ;+	
		jnz .go_on0		  ;+
		xor al, al		  ;+	return 0
		jmp .bye0		  ;+
.found0:	inc al			  ;+	return > 0
.bye0:		pop ecx			  ;+
 		pop edi			  ;+
%endmacro 				  ;+
;+++++++++++++++++++++++++++++++++++++++++++

;+++++++++++++++++++++++++++++++++++++++++++
;+  		search_in_row		   +
;+-----------------------------------------+   
;+args: edi = addr(sudoku)		   +
;+	dl  = number        	           +
;+	al  = row                          +
;+ret : > 0 if found else 0                +
;+++++++++++++++++++++++++++++++++++++++++++
%macro search_in_row 0			  ;+
		push edi		  ;+
		push ecx		  ;+ 
		mov cl, 10		  ;+
		add edi, eax		  ;+
		mov al, dl		  ;+
		repne scasb		  ;+
		xor al, al                ;+
		or cl, cl		  ;+
		setnz al		  ;+
		pop ecx			  ;+
		pop edi			  ;+
%endmacro				  ;+
;+++++++++++++++++++++++++++++++++++++++++++

;+++++++++++++++++++++++++++++++++++++++++++
;+   		search_in_sqr              +
;+-----------------------------------------+
;+args: edi = addr(sudoku)		   +
;+	dl  = number			   +
;+      ebx = (row|col)		           +
;+ret : > 0 if found , else 0	           +
;+++++++++++++++++++++++++++++++++++++++++++
%macro search_in_sqr 0			  ;+
		push edi                  ;+
		push ecx                  ;+
		add edi, eax              ;+
		mov cl, 3                 ;+
.search:	cmp byte[edi+0], dl       ;+
		je .found2                ;+
		cmp byte[edi+1], dl       ;+
		je .found2                ;+
		cmp byte[edi+2], dl       ;+
		je .found2                ;+
		add edi, 9                ;+
		dec cl                    ;+
		jnz .search               ;+
		xor al, al                ;+
		jmp .bye2                 ;+
.found2:	inc al                    ;+
.bye2:		pop ecx                   ;+
		pop edi                   ;+
%endmacro                                 ;+
;+++++++++++++++++++++++++++++++++++++++++++

;+++++++++++++++++++++++++++++++++++++++++++
;+		print_sudoku		   +
;+-----------------------------------------+
;args:	edi = addr(sudoku)		   +
;+++++++++++++++++++++++++++++++++++++++++++
%macro print_sudoku 0			  ;+
		mov cl, SUDO_SZ		  ;+
		lea esi, [buf]		  ;+
		push esi		  ;+
.to_ascii:	mov dl, byte[edi]	  ;+
		add dl, 48		  ;+
		mov byte[esi], dl	  ;+
		inc edi 		  ;+
		inc esi			  ;+
		mov byte[esi], ' '	  ;+
		inc esi			  ;+
		dec cl			  ;+
		jnz .to_ascii		  ;+
		pop esi			  ;+
		push esi		  ;+
		mov cl, 9		  ;+
.do_nl:		add esi, 17		  ;+
		mov byte[esi],LF	  ;+
		inc esi			  ;+
		dec cl			  ;+
		jnz .do_nl		  ;+
.ok:		pop esi 		  ;+
		Write STDOUT, esi, 9*18	  ;+
%endmacro				  ;+
;+++++++++++++++++++++++++++++++++++++++++++		  

;+++++++++++++++++++++++++++++++++++++++++++
section .bss				  ;+
					  ;+
buf     	resb BUF_SZ		  ;+
sudoku		resb SUDO_SZ 		  ;+
ptr_buf 	resb SUDO_SZ		  ;+
;+++++++++++++++++++++++++++++++++++++++++++

;+++++++++++++++++++++++++++++++++++++++++++
section .data				  ;+
					  ;+
missing  db 00			  	  ;+
					  ;+
pre_cal  db 00,00,00,  03,03,03,  	  ;+
	 db 06,06,06,  00,00,00,	  ;+
         db 03,03,03,  06,06,06,  	  ;+
	 db 00,00,00,  03,03,03,	  ;+
         db 06,06,06,  27,27,27,  	  ;+
	 db 30,30,30,  33,33,33,	  ;+
	 db 27,27,27,  30,30,30,  	  ;+
	 db 33,33,33,  27,27,27,	  ;+
         db 30,30,30,  33,33,33,  	  ;+
	 db 54,54,54,  57,57,57,	  ;+
	 db 60,60,60,  54,54,54,  	  ;+
	 db 57,57,57,  60,60,60,	  ;+
  	 db 54,54,54,  57,57,57,  	  ;+
	 db 60,60,60			  ;+
;+++++++++++++++++++++++++++++++++++++++++++

section .text

global _start

;align 4
_start:	
;++++++++++++++++++++++++++++++++++++++++++
;	read sudoku from STDIN, skip	  +
;	white spaces and convert the	  +
;	ascii-codes.			  +
;++++++++++++++++++++++++++++++++++++++++++
		Read STDIN, buf, BUF_SZ  ;+	read sudoku
		xor eax, eax		 ;+
		xor ecx, ecx		 ;+
.L1:		cmp byte[buf+eax], LF	 ;+	if [buf+eax] = LF
		je .skip		 ;+     or
		cmp byte[buf+eax], ' '	 ;+     [buf+eax] = ' '
		je .skip		 ;+     or
		cmp byte[buf+eax], TAB   ;+ 	[buf+eax] = TAB
		je .skip		 ;+	then skip
		mov dl, byte[buf+eax]	 ;+	
		sub dl, 48		 ;+	we need the value, 
					 ;+	not the ascii-code. 
		mov [sudoku+ecx], dl	 ;+
		inc cl			 ;+
		cmp cl, SUDO_SZ		 ;+
		je .get_pos 		 ;+
.skip:		inc ax			 ;+	skip one byte
		jmp .L1			 ;+
;++++++++++++++++++++++++++++++++++++++++++

;++++++++++++++++++++++++++++++++++++++++++
;	  save the positions of 	 ;+
;	missing numbers in ptr_buf.	 ;+
;++++++++++++++++++++++++++++++++++++++++++
.get_pos:	xor ebx, ebx		 ;+ 
		lea edi, [sudoku]	 ;+
		lea esi, [ptr_buf]	 ;+
		push esi		 ;+
		mov cl,  SUDO_SZ	 ;+
.get_next:	cmp byte[edi+ebx], 0	 ;+	
		je .save_index		 ;+
		inc ebx			 ;+
		dec cl			 ;+
		jnz .get_next	 	 ;+
		jmp .main		 ;+
.save_index:	mov byte[esi], bl	 ;+
		inc esi			 ;+
		inc ebx			 ;+
		inc byte[missing]	 ;+
		dec cl			 ;+
		jnz .get_next		 ;+
;++++++++++++++++++++++++++++++++++++++++++

;++++++++++++++++++++++++++++++++++++++++++
.main:		pop esi			 ;+	esi = ptr_buf
		mov dh, 9
		mov cl,  [missing]	 ;+	number of missing numbers
		jmp .solve		 ;+
.back_track:	mov byte[edi+ebx], 0	 ;+
		inc cl			 ;+
		dec esi			 ;+		
.solve:		mov bl,  byte[esi] 	 ;+	position of missing number
		mov dl,  byte[edi+ebx]	 ;+                       
		inc dl			 ;+
		cmp dl, 10		 ;+	we've tryed 1,2,...,9
		jge .back_track		 ;+     ... so, go back
		mov al, bl		 ;+
		div dh			 ;+
		mov [missing], ah	 ;+	store col
		xor ah, ah		 ;+
		mul dh			 ;+
		search_in_row	 	 ;+
		or  al, al		 ;+
		jnz .got_it		 ;+
		mov al, [missing]	 ;+	restore col
		search_in_col	 	 ;+
		or  al, al		 ;+
		jnz .got_it		 ;+
		mov al, byte[pre_cal+ebx];+
		search_in_sqr	 	 ;+
		or al, al		 ;+
		jnz .got_it		 ;+
		mov byte[edi+ebx], dl	 ;+
		inc esi			 ;+
		dec cl 			 ;+
		jnz .solve 		 ;+
		jmp .done 		 ;+
.got_it:	mov byte[edi+ebx], dl    ;+	next number
		jmp .solve		 ;+
.done:		print_sudoku	 	 ;+
		Exit  0			 ;+
;++++++++++++++++++++++++++++++++++++++++++		
kernel:		int KERNEL_INT
		ret

