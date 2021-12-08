## standard format
- Operation [DestNumber] [SrcNumber]

## Data Type
- Immediate Number
	- 8/16/32 bits
	- only used for SrcNumber
	- eg: mov ax,1234h
				mov bl, 22h
				mov edx, 12345678h
- Register
	- 8/16/32 bits
	- eg: mov ax, bx
				mov dl, ch
				mov ecx, eax
- Storage
	- [Reg/Symbol] // Symbol can be used without '[]'
	- eg: mov esi, 1200h
				mov al, [esi]
				mov ax, [esi]

## Address Method
### Immediate Addressing
- mov ax, 1200h // src is an immediate number
### Register Addressing
- mov ax, bx
### Direct Addressing
- mov ax, var1 // src is a variable
- 16 mode
	- mov ax, [1200h] // is also a Direct Addressing
- 32 mode
	- mov ax, [1200h] is equivalent to mov ax, 1200h
### Register Indirect Addressing
- lea ebx, var1 // ebx get var1 address
	mov ax, [ebx]
- indirect registers can only be 8*32 bits general registers
- operand segment address depend on indirect reg type
	- ebp, esp : default ss (stack segment)
	- others : default ds (data segment)

### Register Relative Addressing
- mov ax, [ebx + data]
- mov ax, data[ebx]
- mov ax, [ebx]+data // data can be symbol or immediate number

### Base-Variable addressing
- 32 mode
- mov ebx, addr[esi*2]
- mov eax, [edi*4][edx]
- mov ebx, [edi*8][ebp+10] // can only be 2, 4 or 8

- 16 mode
- eg. mov si, 2000h
			mov bx, 200h
			mov ax, [si+bx]

## Data Transition
### General Data Transition
- feature: don't affect symbol bits
- mov dest, src
	- length equal
	- storage units can't transmit between directly
	- CS can only be src, Segment Reg cant transmit between directly
	- when src is immedate number, dest can't be segment regs
	- eg. mov al, '*'
				mov al, 2ah
				mov 100[edi], al
- movzx reg32, reg/mem8
- movzx reg32, reg/mem16
- movzx reg16, reg/mem8
	- high bits fill with 0
	- eg. mov bx, 0a68ch
				movzx eax, bx
				movzx edx, bl
				movzx cx, bh
- movzx reg32, reg/mem8
- movzx reg32, reg/mem16
- movzx reg16, reg/mem8
	- high bits fill with src highest bit
	- eg. mov bx, 0A68CH
				movsx eax, bx    ;EAX=FFFFA68CH
				movsx edx,bl      ;EDX=FFFFFF8CH
				movsx cx,bh       ;CX  =FFA6H
### Stack Transition
- 16 mode
	- operand has to be 16 bits
	- operand can't be immediate number
	- can't pop to CS
	- operand can be 16 bits reg or storage (need to be declared as word(2 bytes) storage unit)	
	- push operand // from high to low
	- pop operand // from low to high
	- pushf // FLAGS push
	- popf // FLAGS pop
- 32 mode
	- 16 mode compatible
	- push operand can be immediate number
	- new instruction:
		- pusha // push 8*16 bits general reg to stack, in order of ax,cx,dx,bx,sp,bp,si,di
		- pushd // push 8*32 bits general reg to stack, in order of eax,ecx,edx,ebx,ebp,esi,edi
		- popa // reverse of pusha
		- popd // reverse of pushd
		- pushfd // 32 bits version pushfd
		- popfd // 32 bits  version popfd
### Swap Instruction
- xchg reg/mem, mem/reg
	- at least one register
	- segment reg not allowed
### I/O
- in acc, port // port is port address; acc is accumulator, for 16 mode, can be al or ax, for 32 mode, can also be eax
- out port, acc 
#### PORT Addressing Method // both for 16/32 mode
- Direct Addressing 
	- asign PORT a uint_8
	- range 0~255
- Indirect Addressing
	- if port address > 255; then port has to be DX (EDX not allowed), 16 bits
- eg.
	- in ax, 80h
	- mov dx, 2400h
	- in al, dx
	- out 35h, eax
### Address Transition
- lea reg, mem
- src operand has to be a mem
- dest operand has to be a 16/32 bits general reg
- eg.
	- assuming eax=100h
	- mov ebx, [eax] // then ebx is DS+eax location data 
	- lea ebx, [eax] // then ebx is eax, emm... seems equal to mov ebx, eax?
	- mov esi, DATA1 // then esi is DATA1 location data
	- lea esi, DATA1 // then esi is DATA1 number(just like a pointer)

### Flags Operation
- lahf // push low 8 bits of FLAGS to ah
- sahf // reverse of lahf

## Arithmetic Instruction
- most of this kind influence on FLAGS
### Add
- operand basically the same as mov
- add operand1, operand2 // influence all 6 bits of FLAGS 
- adc operand1, operand2 // operand1 + operand2 + CF => operand1 , often used for multi-bytes add, influence all 6 bits of FLAGS
- inc operand // self increase by 1, no influence on FLAGS

### Sub
- operand the same as add
- sub operand1, operand2 // influence all 6 bits of FLAGS
- sbb operand1, operand2 // operand1 - operand2 - CF => operand1, influence all 6 bits of FLAGS
- dec operand // self decrease by 1, no influence on FLAGS
- neg operand // 0 - operand => operand influence pf, af, zf, sf, cf(when oprd 0, cf=0; else 1), of(when oprd is 1B -128(80h), 2B -32768(8000h), 4B 80000000h, result no effect, but overflow flag is 1)
- cmp operand1, operand2 // operand1 - operand2, no storage for result, influence all 6 bits of FLAGS
	-eg. cmp ax, bx // unsigned int
		- if ax > bx, cf=0, zf=0;
		- if ax < bx, cf=1, zf=0;
		- if ax = bx, zf=1
	-eg. cmp ax, bx // signed int
		- if ax > bx, of=sf, zf=0;
		- if ax < bx, of!=sf, zf=0;
		- if ax = bx, zf=1

### Multiply
- mul operand // (al)*(operand) => ax; (ax)*(operand) => dx:ax, (eax)*(operand) => edx:eax
	- operand has to be reg or mem
	- influence on cf, of, if ah/dx/edx = 0, then cf=of=0; else cf=of=1
- imul operand // the same as mul
	- if ah/dx/edx is sign extension, then cf=of=0; else cf=of=1
  - 若乘积的(AH)=11111111，且AL最高位为1，表示符号扩展, 则CF=OF=0
  - 若乘积的(AH)=00000000，且AL最高为0，表示符号扩展, 则CF=OF=0
  - 若乘积的(AH)=11111111，但AL最高位为0，不是符号扩展, 则CF=OF=1
  - 若乘积的(AH)=11111110，不是符号扩展, 则CF=OF=1
  - 若乘积的(AH)=00000010，不是符号扩展, 则CF=OF=1。
- imul dest, src // 32 mode new format
	- dest*src => dest
	- imul reg16, reg/mem16
	- imul reg16, imm8/imm16
	- imul reg32, reg/mem32
	- imul reg32, imm8/imm16/imm32
- imul dest, src1, src2 // 32 mode new format
	- src1*src2 => dest
	- imul reg16, reg/mem16, imm8/imm16
	- imul reg32, reg/mem32, imm8/imm16/imm32 
	- if high bits were dropped, cf=of=1

### Division
- signed:
	- div reg/mem8
	- div reg/mem16
	- div reg/mem32
- unsigned:
	- idiv reg/mem8
	- idiv reg/mem16
	- idiv reg/mem32
- ax / reg/mem8 = al...ah
- dx:ax / reg/mem16 = ax...dx
- edx:eax / reg/mem32 = eax...edx
- divided operand has to be double length of divider operand

### Extend
- cbw // al sign bit extented to ah
	- eg. if al top bit is 1, then ah=ffh; if 0, then ah=00h
- cwd // ax sign bit extented to dx
	- eg. if ax top bit is 1, then dx=ffffh; if 0, then dx=0000h
- cdq // eax sign bit extented to edx
	- eg. if eax top bit is 1, then edx=ffffffffh; if 0, then edx=00000000h


## Logical Operation
- operand basically the same as mov
- operand of NOT can't be immedate number
- NOT don't influence on FLAGS, others set of=cf=0, sf,zf,pf due to result
- AND operand1, operand2
- OR operand1, operand2
- NOT operand
- XOR operand1, operand2
- TEST operand1, operand2
	- do AND, don't store result

## Shift Operation
- shift time given by cl (range 0~255), 16 mode shift once
### Non-Loop Shift
- sal operand, imm8 // arithmetic left shift
- sal operand, cl // top bit send to cf, low bit get 0
- shl operand, imm8 // logical left shift
- shl operand, cl // actually, sal, shl are the same

- sar operand, imm8 // arithmetic right shift
- sar operand, cl // bottom bit send to cf, top bit get sign
- shr operand, imm8 // logical right shift
- shr operand, cl // bottom bit send to cf, top bit get 0

### Loop Shift ???
- rol operand, imm8/cl // without sign bit 
- ror operand, imm8/cl // without sign bit 
- rcl operand, imm8/cl // with sign bit 
- rcr operand, imm8/cl // with sign bit 


### Double Shift // 32 mode
- shld dest, source, count
	- count is cl or imm8
	- dest can be reg or mem
	- source can be reg
	- dest length equal with source
	- dest << count, low bits fill with source
	- influence on sf,zf,af,pf,cf
- shrd dest, source, count

## String Operation
- source address given by [ESI]
- destination address given by [EDI]
- 16 mode
	- source base address given by DS
	- destination base address given by ES
- if DF=0, increase direction; else decrease direction

### Repeat
- REP // repeat ecx times
- REPE // if zf=1, then repeat ecx times
- REPZ // if zf=1, then repeat ecx times
- REPNZ // if zf=0, then repeat ecx times
- REPNZ // if zf=1, then repeat ecx times

### String Mov // no influence on FLAGS
- movs operand1, operand2
- movsb operand1, operand2
- movsw operand1, operand2
- movsd operand1, operand2
- eg.
	LEA  ESI，MEM1
	LEA  EDI，MEM2
	MOV  ECX，200 
	CLD
	REP  MOVSB
	HLT
### String Cmp
- cmps operand1, operand2
- cmpsb operand1, operand2
- cmpsw operand1, operand2
- cmpsd operand1, operand2
- eg.
	LEA  ESI，MEM1
	LEA  EDI，MEM2
	MOV  ECX，200
	CLD 
	REPE   CMPSB
  JZ  STOP
  DEC  ESI
  MOV  AL，[ESI]
  MOV  EBX，ESI
	STOP：HLT  

### String Scan // find a certain bytes(s)
- scas operand // string address given by EDI
- scasb operand
- scasw operand
- scasd operand

### String Load
- lods operand // string address given by EDI
- lodsb operand
- lodsw operand
- lodsd operand
- 用于将内存某个区域的数据串依次装入累加器，以便进行处理（如显示或输出到接口）
- no REPE
### String Store
- stos operand // string address given by EDI
- stosb operand
- stosw operand
- stosd operand


## Program Control
### Jump
- jmp operand // operand can be direct addressing or indirect addressing
- direct addressing
	- operand can be a label or 2/4 bits long offset(base EIP)
- indirect addressing
	- operand is a 32 bits long general reg
	- eg. jmp ebx
- jc/jnc // depend on cf
- jz/jnz // depend on zf
- jo/jno // depend on of
- jp/jnp // depend on pf
- ja/jae/jb/jbe // depend on cf or cf+zf
- jg/jge/jl/jle // depend on sf, of, zf
- jcxz/jecxz // depend on cx or ecx


### Loop
- loop label
- condition: ecx!=0

### Invoke
- modify cs:ip/eip
### Return
- RET
- pop address from stack, and jmp
### Interrupt
- INT n // n range 0~255
	- push FLAGS/EFLAGS
	- push CS:IP
	- n*4 get int vector address
	- mov vector address to CS:IP
- INTO // interrupt on OF=1, equal to INT 4
- IRET // interrupt program last instruction, restore CS:IP, FLAGS

### CPU Control
- 清除进位标志 CLC
- 置1进位标志STC
- 进位标志取反CMC
- 清除方向标志CLD
- 置1方向标志STD
- 清除中断标志CLI
- 置1中断标志STI
