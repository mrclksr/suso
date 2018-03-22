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

%define SYS_EXIT	0x1
%define SYS_READ	0x3
%define SYS_WRITE	0x4
%define SYS_OPEN	0x5
%define SYS_CLOSE	0x6

%define STDIN		0x0
%define STDOUT		0x1
%define STDERR		0x2
%define KERNEL_INT	0x80

%macro  Read  3
	push dword %3
	push dword %2
	push dword %1
	mov eax, SYS_READ
	call kernel
%endmacro


%macro  Write 3
	push dword %3
	push dword %2
	push dword %1
	mov  eax, SYS_WRITE
	call kernel
%endmacro

%macro  Exit 1
	push dword %1
	mov eax, SYS_EXIT
	call kernel
%endmacro

