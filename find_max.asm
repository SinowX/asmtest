.386
.MODEL flat,stdcall
.STACK 4096
ExitProcess PROTO,dwExitCode:DWORD

.DATA
ARY DB 17,5,40,0,67,12,34,78,32,10
MAX DB ?

.CODE
MAIN PROC
	mov esi, offset ARY
	mov cx, 9
	mov al, [esi]
LOP:
	inc esi
	cmp al, [esi]
	jae BIGER
	mov al,[esi]
BIGER:
	dec cx
	jnz lop
	mov max, al
	invoke ExitProcess, 0
MAIN ENDP
END MAIN
