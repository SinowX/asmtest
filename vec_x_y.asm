.386
.MODEL flat,stdcall
.STACK 4096
ExitProcess PROTO,dwExitCode:DWORD

.DATA
X  DB 0A2H,7CH,34H,9FH,0F4H,10H,39H,5BH
Y  DB 14H,05BH,28H,7AH,0EH,13H,46H,2CH
LEN EQU $-Y
Z DB LEN DUP(?)
LOGR DB 10011010B

.CODE
MAIN PROC
	mov ecx, LEN
	mov esi, 0
	mov bl, LOGR
LOP:
	mov al, X[ESI]
	shr bl, 1
	jc SUB1
	add al, Y[ESI]
	jmp RES
SUB1:
	sub al,Y[ESI]
RES:
	mov Z[esi], al
	inc esi
	loop LOP
	invoke ExitProcess,0
MAIN ENDP
END MAIN
