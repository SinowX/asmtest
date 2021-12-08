.386
.MODEL flat,stdcall
.STACK 4096
ExitProcess PROTO,dwExitCode:DWORD

.DATA
VARW DW 1101010010001000B
CONT DB ?

.CODE
MAIN PROC
	mov cl, 0
	mov ax, varw
LOP:
	test ax, 0ffffh
	jz END0
	jns shift
	inc cl
SHIFT:
	shl ax, 1
	jmp lop
END0:
	mov cont, cl
	invoke ExitProcess,0
MAIN ENDP
END MAIN
