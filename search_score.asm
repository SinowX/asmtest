.386
.model flat,stdcall
.stack 4096
include Irvine32.inc
includelib Irvine32.lib
ExitProcess PROTO,dwExitCode:DWORD

.data
table DB 81,78,90,64,85,76,93,82,57,80
			DB 73,62,87,77,74,86,95,91,82,71
math DB ?

.code
main PROC
	mov ebx, offset table
	xor eax, eax
	call ReadDec
	dec eax
	add ebx, eax
	xor eax, eax
	mov al, [ebx]
	mov math, al
	call WriteDec
	invoke ExitProcess,0
main ENDP
END main
