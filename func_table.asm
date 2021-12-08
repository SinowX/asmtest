.386
.MODEL flat,stdcall
.STACK 4096
ExitProcess PROTO,dwExitCode:DWORD

.DATA
ATABLE DWORD BRAN1,BRAN2,...,BRAN10
N BYTE 3

.CODE
MAIN PROC
	xor eax, eax
	mov al, n
	dec al
	shl al, 2
	mov ebx, offset ATABLE
	add ebx, eax
	mov ecx, [ebx]
	jmp ecx
BRAN1 LABEL NEAR
	...
	jmp END1
BRAN2 LABEL NEAR
	...
	jmp END1
BRAN10 LABEL NEAR
	...
	jmp END1

END1:
	INVOCK ExitProcess,0
MAIN ENDP
END MAIN
