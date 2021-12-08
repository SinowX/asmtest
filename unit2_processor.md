# 8088 min mode
- AD0~AD7
	low 8 bits
	address(simplex) data(duplex) signal time sharing
- A8~A15
	8 bits
	address signal
- A16~A19/S3-S6
	high 4 bits
	address ,data signal time sharing

- ^WR
	write signal
- ^RD
	read signal
- IO/^M
	0: access memory
	1: access io
- ^DEN
	0: data bus effective, allow r/w
- DT/^R ()
	0: mem/io=>cpu
	1: cpu=>mem/io
- ALE (Address Latch Enable)
	1: address bus effective
- RESET
	1: reset cpu internal register
		CS: 0xffff
		DS: 0x0000
		SS: 0x0000
		ES: 0x0000
		IP: 0x0000
		FLAGS: 0x0000
		others: 0x0000
		instruction queue: null
- READY
	1: sync outside(io/memory)
- INTR
	Maskable Interrupt Input Port
	
- NMI
	Non Maskable Interrupt Input Port
- ^INTA
	Interrupt Response Output Port

# 8088 8086 differences
- outer data bus
	8088: 8bits
	8086: 16bits
- IO/^M (8088) ^IO/M (8086)

# 8086 CPU structure
## EU (Execute Unit)
- ALU (Algorithm and Logical Unit)
- 8 General Registers
- 1 Flag Register
- control unit

1. Decode
2. Execute (ALU)
3. Temporary Storage (General Registers)
4. Save Execute Flags (FLAGS Reg)

## BIU (Bus Interface Unit)
- Address Adder
- 4 Segment Registers
- Instruction Pointer
- control unit

1. Fetch (fetch to instruction queue)
2. Cope with Memory, I/O data flow
3. When Execute Jump
	- clear instruction queue
	- fetch new instruction
	- pass to execute unit

## Instruction Queue allows Execute Parallel


# Internal Registers
- 8 General Regs
	- Data Regs
		- AX accumulator reg
		- BX base reg
		- CX counter reg
		- DX data reg
	- Address Regs
		- SP stack pointer
		- BP base pointer
	- Index Regs
		- SI source index reg
		- DI destination index reg
- 4 Segment Regs
	- CS code segment
	- DS data segment
	- ES extra segment
	- SS stack segment
- 2 Control Regs
	- IP instruction pointer
	- FLAGS
		- CF carry flag
		- PF parity flag
		- AF auxiliary carry flag 
		- ZF zero flag
		- SF sign flag
		- OF overflow flag
		- TF trap flag
		- IF interrupt enable flag
		- DF direction flag

# 8086/88 storage
## pysical address
	- 20 address lines
	- rangement 0~2^(20)-1, 0x00000~0xfffff
## logical address
	- 16 bits segment address
	- 16 bits offset address
		- 2^16 max length for a segment

# Procted Mode
## Segment Descriptor
- 64 bits/8 bytes
- Segment Address 32 bits
- Segment Limit 20 bits
- Flags 12 bits
	- DPL
		- each segment has a privilege level
		- rangement: 0~3, 0 is highest level
	- Segment Type
		- rangement: r,w,x, segment grow direction
	- Segment If Exists in Memory
	- Granularity
		- G=0 bytes
		- G=1 4 Kbytes
		- This flag influences Segment Limit(1~1MB/4KB~4GB)

## Segment Selector
- GPL/RPL: 0~1
	- current code/data privilege
	- if CS, then CPL; else RPL
- TI: 2
	- 0: GDT
	- 1: LDT
- INDEX: 3~15
	- offset in description table
