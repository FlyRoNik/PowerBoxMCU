
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega328P
;Program type             : Application
;Clock frequency          : 16,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega328P
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2303
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x08FF
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _Permit=R4
	.DEF _counter_digitizing=R3
	.DEF _checksum=R6
	.DEF _current=R7
	.DEF _voltage=R9
	.DEF _avarage_current=R11
	.DEF _avarage_voltage=R13
	.DEF _status_power=R5

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _twi_int_handler
	JMP  0x00

_0x2000003:
	.DB  0x7

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _twi_result
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	WDR
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	STS  WDTCSR,R31
	STS  WDTCSR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x300

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.3 Standard
;Automatic Program Generator
;© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 27.04.2017
;Author  : Nikita
;Company :
;Comments:
;
;
;Chip type               : ATmega328P
;Program type            : Application
;AVR Core Clock frequency: 16,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*****************************************************/
;
;#include <mega328p.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;// TWI functions
;#include <twi.h>
;
;bit b1, status_phone, status_lock, status_LED;
;unsigned char Permit, counter_digitizing, checksum;
;
;unsigned int current, voltage, avarage_current, avarage_voltage;
;unsigned char status_power;
;
;unsigned char read_command, current_command, i, size_commands, write_command, color_R, color_G, color_B;
;
;//I2C Bus Slave Address
;#define SLAVE_ADDRESS 0x0f //10 = 0x0a
;
;//Restrictive current
;#define RESTRICTIVE_CURRENT 1000 //700 = 2A
;
;//minimum supply current
;#define MIN_SUPPLY_CURRENT 50
;
;// TWI Slave receive buffer
;#define TWI_RX_BUFFER_SIZE 13
;unsigned char twi_rx_buffer[TWI_RX_BUFFER_SIZE];
;
;// TWI Slave transmit buffer
;#define TWI_TX_BUFFER_SIZE 21
;unsigned char twi_tx_buffer[TWI_TX_BUFFER_SIZE];
;
;
;void setPower(char x){
; 0000 0036 void setPower(char x){

	.CSEG
_setPower:
; 0000 0037     PORTD.5 = x;
	ST   -Y,R26
;	x -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x3
	CBI  0xB,5
	RJMP _0x4
_0x3:
	SBI  0xB,5
_0x4:
; 0000 0038     status_power = x;
	LDD  R5,Y+0
; 0000 0039 }
	RJMP _0x2040001
;
;// TWI Slave receive handler
;// This handler is called everytime a byte
;// is received by the TWI slave
;bool twi_rx_handler(bool rx_complete)
; 0000 003F {
_twi_rx_handler:
; 0000 0040 if (twi_result==TWI_RES_OK)
	ST   -Y,R26
;	rx_complete -> Y+0
	LDS  R30,_twi_result
	CPI  R30,0
	BREQ PC+3
	JMP _0x5
; 0000 0041    {
; 0000 0042    // A data byte was received without error
; 0000 0043    // and it was stored at twi_rx_buffer[twi_rx_index]
; 0000 0044    // Place your code here to process the received byte
; 0000 0045    // Note: processing must be VERY FAST, otherwise
; 0000 0046    // it is better to process the received data when
; 0000 0047    // all communication with the master has finished
; 0000 0048    if(((twi_rx_buffer[0]>3) && (twi_rx_buffer[0] < 22)) && ((twi_rx_buffer[1]==0 || (twi_rx_buffer[1]==1)))){
	LDS  R26,_twi_rx_buffer
	CPI  R26,LOW(0x4)
	BRLO _0x7
	CPI  R26,LOW(0x16)
	BRLO _0x8
_0x7:
	RJMP _0x9
_0x8:
	__GETB2MN _twi_rx_buffer,1
	CPI  R26,LOW(0x0)
	BREQ _0xA
	__GETB2MN _twi_rx_buffer,1
	CPI  R26,LOW(0x1)
	BRNE _0x9
_0xA:
	RJMP _0xC
_0x9:
	RJMP _0x6
_0xC:
; 0000 0049 
; 0000 004A 
; 0000 004B    checksum = 0;
	CLR  R6
; 0000 004C     for (i = 0; i < twi_rx_buffer[0] - 1; i++) {
	LDI  R30,LOW(0)
	STS  _i,R30
_0xE:
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	BRGE _0xF
; 0000 004D         checksum += twi_rx_buffer[i];
	CALL SUBOPT_0x2
	ADD  R6,R30
; 0000 004E     };
	CALL SUBOPT_0x3
	RJMP _0xE
_0xF:
; 0000 004F 
; 0000 0050     if(checksum == twi_rx_buffer[twi_rx_buffer[0] - 1]){
	CALL SUBOPT_0x0
	SUBI R30,LOW(-_twi_rx_buffer)
	SBCI R31,HIGH(-_twi_rx_buffer)
	LD   R30,Z
	CP   R30,R6
	BREQ PC+3
	JMP _0x10
; 0000 0051     checksum = 0;
	CLR  R6
; 0000 0052     read_command = 0;
	LDI  R30,LOW(0)
	STS  _read_command,R30
; 0000 0053     current_command = 0;
	STS  _current_command,R30
; 0000 0054     size_commands = 1;
	LDI  R30,LOW(1)
	STS  _size_commands,R30
; 0000 0055     write_command = 0;
	LDI  R30,LOW(0)
	STS  _write_command,R30
; 0000 0056     if (twi_rx_buffer[1] == 0) {        //command set
	__GETB1MN _twi_rx_buffer,1
	CPI  R30,0
	BREQ PC+3
	JMP _0x11
; 0000 0057         for (i = 2; i < twi_rx_buffer[0] - 1; i++) {  //twi_rx_buffer[0] - count command
	LDI  R30,LOW(2)
	STS  _i,R30
_0x13:
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	BRLT PC+3
	JMP _0x14
; 0000 0058                 if (read_command == 0) {
	LDS  R30,_read_command
	CPI  R30,0
	BRNE _0x15
; 0000 0059                     current_command = twi_rx_buffer[i];
	CALL SUBOPT_0x2
	STS  _current_command,R30
; 0000 005A                     read_command = 1;
	LDI  R30,LOW(1)
	RJMP _0xA2
; 0000 005B                 }
; 0000 005C                 else{
_0x15:
; 0000 005D                     switch (current_command) {
	CALL SUBOPT_0x4
; 0000 005E                         case 0:{   //set power
	BRNE _0x1A
; 0000 005F                             switch(twi_rx_buffer[i]){
	CALL SUBOPT_0x2
	LDI  R31,0
; 0000 0060                                 case 0: setPower(1); //OFF
	SBIW R30,0
	BREQ _0xA3
; 0000 0061                                     break;
; 0000 0062                                 case 1: setPower(0); //ON
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1F
	LDI  R26,LOW(0)
	RJMP _0xA4
; 0000 0063                                     break;
; 0000 0064                                 case 2: setPower(2); //FAIL
_0x1F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x21
	LDI  R26,LOW(2)
	RJMP _0xA4
; 0000 0065                                     break;
; 0000 0066                                  default: setPower(1); //OFF
_0x21:
_0xA3:
	LDI  R26,LOW(1)
_0xA4:
	RCALL _setPower
; 0000 0067                             };
; 0000 0068 
; 0000 0069                             read_command = 0;
	RJMP _0xA5
; 0000 006A                         }
; 0000 006B                         break;
; 0000 006C                         case 1:{    //set color rgb
_0x1A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x22
; 0000 006D                             switch (read_command) {
	LDS  R30,_read_command
	CALL SUBOPT_0x5
; 0000 006E                                  case 1: PORTB.3 = twi_rx_buffer[i]; //color_R
	BRNE _0x26
	CALL SUBOPT_0x2
	CPI  R30,0
	BRNE _0x27
	CBI  0x5,3
	RJMP _0x28
_0x27:
	SBI  0x5,3
_0x28:
; 0000 006F                                     break;
	RJMP _0x25
; 0000 0070                                  case 2: PORTB.2 = twi_rx_buffer[i]; //color_G
_0x26:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x29
	CALL SUBOPT_0x2
	CPI  R30,0
	BRNE _0x2A
	CBI  0x5,2
	RJMP _0x2B
_0x2A:
	SBI  0x5,2
_0x2B:
; 0000 0071                                     break;
	RJMP _0x25
; 0000 0072                                  case 3: PORTB.1 = twi_rx_buffer[i]; //color_B
_0x29:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x25
	CALL SUBOPT_0x2
	CPI  R30,0
	BRNE _0x2D
	CBI  0x5,1
	RJMP _0x2E
_0x2D:
	SBI  0x5,1
_0x2E:
; 0000 0073                                     break;
; 0000 0074                                 };
_0x25:
; 0000 0075                             if(read_command == 3){
	LDS  R26,_read_command
	CPI  R26,LOW(0x3)
	BRNE _0x2F
; 0000 0076                                 read_command = 0;
	LDI  R30,LOW(0)
	RJMP _0xA6
; 0000 0077                             }
; 0000 0078                             else
_0x2F:
; 0000 0079                                 read_command++;
	LDS  R30,_read_command
	SUBI R30,-LOW(1)
_0xA6:
	STS  _read_command,R30
; 0000 007A                         }
; 0000 007B                         break;
	RJMP _0x19
; 0000 007C                         case 2:{    //set LED
_0x22:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x31
; 0000 007D                             PORTD.6 = twi_rx_buffer[i];
	CALL SUBOPT_0x2
	CPI  R30,0
	BRNE _0x32
	CBI  0xB,6
	RJMP _0x33
_0x32:
	SBI  0xB,6
_0x33:
; 0000 007E                             read_command = 0;
	RJMP _0xA5
; 0000 007F                         }
; 0000 0080                         break;
; 0000 0081                         case 3:{    //open door
_0x31:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x19
; 0000 0082                             PORTB.4 = twi_rx_buffer[i];
	CALL SUBOPT_0x2
	CPI  R30,0
	BRNE _0x35
	CBI  0x5,4
	RJMP _0x36
_0x35:
	SBI  0x5,4
_0x36:
; 0000 0083                             read_command = 0;
_0xA5:
	LDI  R30,LOW(0)
_0xA2:
	STS  _read_command,R30
; 0000 0084                         }
; 0000 0085                         break;
; 0000 0086                         };
_0x19:
; 0000 0087                 }
; 0000 0088         };
	CALL SUBOPT_0x3
	RJMP _0x13
_0x14:
; 0000 0089         twi_tx_buffer[0] = 0;
	LDI  R30,LOW(0)
	STS  _twi_tx_buffer,R30
; 0000 008A     }
; 0000 008B     else  {                            //command get
	RJMP _0x37
_0x11:
; 0000 008C         for (i = 0; i < 21; i++) {
	LDI  R30,LOW(0)
	STS  _i,R30
_0x39:
	LDS  R26,_i
	CPI  R26,LOW(0x15)
	BRSH _0x3A
; 0000 008D             twi_tx_buffer[i] = 0;
	CALL SUBOPT_0x6
	SUBI R30,LOW(-_twi_tx_buffer)
	SBCI R31,HIGH(-_twi_tx_buffer)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 008E         };
	CALL SUBOPT_0x3
	RJMP _0x39
_0x3A:
; 0000 008F         for (i = 2; i < twi_rx_buffer[0] - 1; i++) {  //twi_rx_buffer[0] - count command
	LDI  R30,LOW(2)
	STS  _i,R30
_0x3C:
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	BRGE _0x3D
; 0000 0090             twi_tx_buffer[size_commands + 1] = twi_rx_buffer[i];
	CALL SUBOPT_0x7
	__ADDW1MN _twi_tx_buffer,1
	MOVW R26,R30
	CALL SUBOPT_0x2
	ST   X,R30
; 0000 0091             if(twi_rx_buffer[i] == 1){
	CALL SUBOPT_0x6
	SUBI R30,LOW(-_twi_rx_buffer)
	SBCI R31,HIGH(-_twi_rx_buffer)
	LD   R26,Z
	CPI  R26,LOW(0x1)
	BRNE _0x3E
; 0000 0092                 size_commands += 4;
	LDS  R30,_size_commands
	SUBI R30,-LOW(4)
	RJMP _0xA7
; 0000 0093             }else{
_0x3E:
; 0000 0094                 if((twi_rx_buffer[i] == 5) || (twi_rx_buffer[i] == 6)){
	CALL SUBOPT_0x6
	SUBI R30,LOW(-_twi_rx_buffer)
	SBCI R31,HIGH(-_twi_rx_buffer)
	LD   R26,Z
	CPI  R26,LOW(0x5)
	BREQ _0x41
	CPI  R26,LOW(0x6)
	BRNE _0x40
_0x41:
; 0000 0095                     size_commands += 3;
	LDS  R30,_size_commands
	SUBI R30,-LOW(3)
	RJMP _0xA7
; 0000 0096                 }else
_0x40:
; 0000 0097                     size_commands += 2;
	LDS  R30,_size_commands
	SUBI R30,-LOW(2)
_0xA7:
	STS  _size_commands,R30
; 0000 0098             }
; 0000 0099         };
	CALL SUBOPT_0x3
	RJMP _0x3C
_0x3D:
; 0000 009A 
; 0000 009B         size_commands++;
	LDS  R30,_size_commands
	SUBI R30,-LOW(1)
	STS  _size_commands,R30
; 0000 009C 
; 0000 009D         for (i = 2; i < size_commands; i++) {  //twi_rx_buffer[0] - count command
	LDI  R30,LOW(2)
	STS  _i,R30
_0x45:
	LDS  R30,_size_commands
	LDS  R26,_i
	CP   R26,R30
	BRLO PC+3
	JMP _0x46
; 0000 009E             if (write_command == 0) {
	LDS  R30,_write_command
	CPI  R30,0
	BRNE _0x47
; 0000 009F                     current_command = twi_tx_buffer[i];
	CALL SUBOPT_0x6
	SUBI R30,LOW(-_twi_tx_buffer)
	SBCI R31,HIGH(-_twi_tx_buffer)
	LD   R30,Z
	STS  _current_command,R30
; 0000 00A0                     write_command = 1;
	LDI  R30,LOW(1)
	RJMP _0xA8
; 0000 00A1                 }
; 0000 00A2                 else{
_0x47:
; 0000 00A3                     switch (current_command) {
	CALL SUBOPT_0x4
; 0000 00A4                         case 0:{   //get power
	BRNE _0x4C
; 0000 00A5                             switch(status_power){
	MOV  R30,R5
	LDI  R31,0
; 0000 00A6                                 case 0: twi_tx_buffer[i] = 1;; //OFF
	SBIW R30,0
	BRNE _0x50
	CALL SUBOPT_0x6
	SUBI R30,LOW(-_twi_tx_buffer)
	SBCI R31,HIGH(-_twi_tx_buffer)
	LDI  R26,LOW(1)
	RJMP _0xA9
; 0000 00A7                                     break;
; 0000 00A8                                 case 1: twi_tx_buffer[i] = 0; //ON
_0x50:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x51
	CALL SUBOPT_0x6
	SUBI R30,LOW(-_twi_tx_buffer)
	SBCI R31,HIGH(-_twi_tx_buffer)
	LDI  R26,LOW(0)
	RJMP _0xA9
; 0000 00A9                                     break;
; 0000 00AA                                 case 2: twi_tx_buffer[i] = 2; //FAIL
_0x51:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x4F
	CALL SUBOPT_0x6
	SUBI R30,LOW(-_twi_tx_buffer)
	SBCI R31,HIGH(-_twi_tx_buffer)
	LDI  R26,LOW(2)
_0xA9:
	STD  Z+0,R26
; 0000 00AB                                     break;
; 0000 00AC                             };
_0x4F:
; 0000 00AD 
; 0000 00AE                             write_command = 0;
	LDI  R30,LOW(0)
	RJMP _0xA8
; 0000 00AF                         }
; 0000 00B0                         break;
; 0000 00B1                         case 1:{    //get color rgb
_0x4C:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x53
; 0000 00B2                             switch (write_command) {
	CALL SUBOPT_0x8
; 0000 00B3                                  case 1: twi_tx_buffer[i] = color_R;
	BRNE _0x57
	CALL SUBOPT_0x6
	SUBI R30,LOW(-_twi_tx_buffer)
	SBCI R31,HIGH(-_twi_tx_buffer)
	LDS  R26,_color_R
	RJMP _0xAA
; 0000 00B4                                     break;
; 0000 00B5                                  case 2: twi_tx_buffer[i] = color_G;
_0x57:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x58
	CALL SUBOPT_0x6
	SUBI R30,LOW(-_twi_tx_buffer)
	SBCI R31,HIGH(-_twi_tx_buffer)
	LDS  R26,_color_G
	RJMP _0xAA
; 0000 00B6                                     break;
; 0000 00B7                                  case 3: twi_tx_buffer[i] = color_B;
_0x58:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x56
	CALL SUBOPT_0x6
	SUBI R30,LOW(-_twi_tx_buffer)
	SBCI R31,HIGH(-_twi_tx_buffer)
	LDS  R26,_color_B
_0xAA:
	STD  Z+0,R26
; 0000 00B8                                     break;
; 0000 00B9                                 };
_0x56:
; 0000 00BA                             if(write_command == 3){
	LDS  R26,_write_command
	CPI  R26,LOW(0x3)
	BRNE _0x5A
; 0000 00BB                                 write_command = 0;
	LDI  R30,LOW(0)
	RJMP _0xAB
; 0000 00BC                             }
; 0000 00BD                             else
_0x5A:
; 0000 00BE                                 write_command++;
	LDS  R30,_write_command
	SUBI R30,-LOW(1)
_0xAB:
	STS  _write_command,R30
; 0000 00BF                         }
; 0000 00C0                         break;
	RJMP _0x4B
; 0000 00C1                         case 2:{    //get status_LED
_0x53:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x5C
; 0000 00C2                             twi_tx_buffer[i] = status_LED;
	CALL SUBOPT_0x9
	LDI  R30,0
	SBIC 0x1E,3
	LDI  R30,1
	ST   X,R30
; 0000 00C3                             write_command = 0;
	LDI  R30,LOW(0)
	RJMP _0xA8
; 0000 00C4                         }
; 0000 00C5                         break;
; 0000 00C6                         case 3:{    //get status_lock
_0x5C:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x5D
; 0000 00C7                             twi_tx_buffer[i] = status_lock;
	CALL SUBOPT_0x9
	LDI  R30,0
	SBIC 0x1E,2
	LDI  R30,1
	ST   X,R30
; 0000 00C8                             write_command = 0;
	LDI  R30,LOW(0)
	RJMP _0xA8
; 0000 00C9                         }
; 0000 00CA                         break;
; 0000 00CB                         case 4:{    //get status_phone
_0x5D:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x5E
; 0000 00CC                             twi_tx_buffer[i] = status_phone;
	CALL SUBOPT_0x9
	LDI  R30,0
	SBIC 0x1E,1
	LDI  R30,1
	ST   X,R30
; 0000 00CD                             write_command = 0;
	LDI  R30,LOW(0)
	RJMP _0xA8
; 0000 00CE                         }
; 0000 00CF                         break;
; 0000 00D0                         case 5:{    //get avarage_current
_0x5E:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x5F
; 0000 00D1                             switch (write_command) {
	CALL SUBOPT_0x8
; 0000 00D2                                  case 1: twi_tx_buffer[i] = avarage_current;
	BRNE _0x63
	CALL SUBOPT_0x6
	SUBI R30,LOW(-_twi_tx_buffer)
	SBCI R31,HIGH(-_twi_tx_buffer)
	ST   Z,R11
; 0000 00D3                                     break;
	RJMP _0x62
; 0000 00D4                                  case 2: twi_tx_buffer[i] = avarage_current>>8;
_0x63:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x62
	CALL SUBOPT_0x9
	ST   X,R12
; 0000 00D5                                     break;
; 0000 00D6                                 };
_0x62:
; 0000 00D7                             if(write_command == 2){
	LDS  R26,_write_command
	CPI  R26,LOW(0x2)
	BRNE _0x65
; 0000 00D8                                 write_command = 0;
	LDI  R30,LOW(0)
	RJMP _0xAC
; 0000 00D9                             }
; 0000 00DA                             else
_0x65:
; 0000 00DB                                 write_command++;
	LDS  R30,_write_command
	SUBI R30,-LOW(1)
_0xAC:
	STS  _write_command,R30
; 0000 00DC                         }
; 0000 00DD                         break;
	RJMP _0x4B
; 0000 00DE                         case 6:{    //get avarage_voltage
_0x5F:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x4B
; 0000 00DF                             switch (write_command) {
	CALL SUBOPT_0x8
; 0000 00E0                                  case 1: twi_tx_buffer[i] = avarage_voltage;
	BRNE _0x6B
	CALL SUBOPT_0x6
	SUBI R30,LOW(-_twi_tx_buffer)
	SBCI R31,HIGH(-_twi_tx_buffer)
	ST   Z,R13
; 0000 00E1                                     break;
	RJMP _0x6A
; 0000 00E2                                  case 2: twi_tx_buffer[i] = avarage_voltage>>8;
_0x6B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x6A
	CALL SUBOPT_0x9
	ST   X,R14
; 0000 00E3                                     break;
; 0000 00E4                                 };
_0x6A:
; 0000 00E5                             if(write_command == 2){
	LDS  R26,_write_command
	CPI  R26,LOW(0x2)
	BRNE _0x6D
; 0000 00E6                                 write_command = 0;
	LDI  R30,LOW(0)
	RJMP _0xA8
; 0000 00E7                             }
; 0000 00E8                             else
_0x6D:
; 0000 00E9                                 write_command++;
	LDS  R30,_write_command
	SUBI R30,-LOW(1)
_0xA8:
	STS  _write_command,R30
; 0000 00EA                         }
; 0000 00EB                         break;
; 0000 00EC                         };
_0x4B:
; 0000 00ED                 }
; 0000 00EE         };
	CALL SUBOPT_0x3
	RJMP _0x45
_0x46:
; 0000 00EF         size_commands++;
	LDS  R30,_size_commands
	SUBI R30,-LOW(1)
	STS  _size_commands,R30
; 0000 00F0         twi_tx_buffer[0] = size_commands;
	STS  _twi_tx_buffer,R30
; 0000 00F1         twi_tx_buffer[1] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _twi_tx_buffer,1
; 0000 00F2         for (i = 0; i < size_commands - 1; i++) {
	LDI  R30,LOW(0)
	STS  _i,R30
_0x70:
	CALL SUBOPT_0x7
	SBIW R30,1
	CALL SUBOPT_0x1
	BRGE _0x71
; 0000 00F3             checksum +=  twi_tx_buffer[i];
	CALL SUBOPT_0x6
	SUBI R30,LOW(-_twi_tx_buffer)
	SBCI R31,HIGH(-_twi_tx_buffer)
	LD   R30,Z
	ADD  R6,R30
; 0000 00F4         };
	CALL SUBOPT_0x3
	RJMP _0x70
_0x71:
; 0000 00F5         twi_tx_buffer[size_commands - 1] = checksum;
	CALL SUBOPT_0x7
	SBIW R30,1
	SUBI R30,LOW(-_twi_tx_buffer)
	SBCI R31,HIGH(-_twi_tx_buffer)
	ST   Z,R6
; 0000 00F6     };
_0x37:
; 0000 00F7     }else{
	RJMP _0x72
_0x10:
; 0000 00F8         twi_tx_buffer[0] = 255;
	LDI  R30,LOW(255)
	STS  _twi_tx_buffer,R30
; 0000 00F9     }
_0x72:
; 0000 00FA     }else{
	RJMP _0x73
_0x6:
; 0000 00FB         twi_tx_buffer[0] = 255;
	LDI  R30,LOW(255)
	STS  _twi_tx_buffer,R30
; 0000 00FC     }
_0x73:
; 0000 00FD 
; 0000 00FE 
; 0000 00FF    }
; 0000 0100 else
	RJMP _0x74
_0x5:
; 0000 0101    {
; 0000 0102    // Receive error
; 0000 0103    // Place your code here to process the error
; 0000 0104 
; 0000 0105    return false; // Stop further reception
	RJMP _0x2040002
; 0000 0106    }
_0x74:
; 0000 0107 
; 0000 0108 // The TWI master has finished transmitting data?
; 0000 0109 if (rx_complete) return false; // Yes, no more bytes to receive
	LD   R30,Y
	CPI  R30,0
	BRNE _0x2040002
; 0000 010A 
; 0000 010B // Signal to the TWI master that the TWI slave
; 0000 010C // is ready to accept more data, as long as
; 0000 010D // there is enough space in the receive buffer
; 0000 010E return (twi_rx_index<sizeof(twi_rx_buffer));
	LDS  R26,_twi_rx_index
	LDI  R30,LOW(13)
	CALL __LTB12U
	RJMP _0x2040001
; 0000 010F }
;
;// TWI Slave transmission handler
;// This handler is called for the first time when the
;// transmission from the TWI slave to the master
;// is about to begin, returning the number of bytes
;// that need to be transmitted
;// The second time the handler is called when the
;// transmission has finished
;// In this case it must return 0
;unsigned char twi_tx_handler(bool tx_complete)
; 0000 011A {
_twi_tx_handler:
; 0000 011B if (tx_complete==false)
	ST   -Y,R26
;	tx_complete -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x76
; 0000 011C    {
; 0000 011D    // Transmission from slave to master is about to start
; 0000 011E    // Return the number of bytes to transmit
; 0000 011F 
; 0000 0120 
; 0000 0121    return sizeof(twi_tx_buffer);
	LDI  R30,LOW(21)
	RJMP _0x2040001
; 0000 0122    }
; 0000 0123 
; 0000 0124 // Transmission from slave to master has finished
; 0000 0125 // Place code here to eventually process data from
; 0000 0126 // the twi_rx_buffer, if it wasn't yet processed
; 0000 0127 // in the twi_rx_handler
; 0000 0128 
; 0000 0129 // No more bytes to send in this transaction
; 0000 012A return 0;
_0x76:
_0x2040002:
	LDI  R30,LOW(0)
_0x2040001:
	ADIW R28,1
	RET
; 0000 012B }
;
;// Declare your global variables here
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0131 {
_timer0_ovf_isr:
; 0000 0132 // Place your code here    16ms
; 0000 0133     b1=0;
	CBI  0x1E,0
; 0000 0134 }
	RETI
;
;
;// Declare your global variables here
;
;void main(void)
; 0000 013A {
_main:
; 0000 013B // Declare your local variables here
; 0000 013C 
; 0000 013D // Crystal Oscillator division factor: 1
; 0000 013E #pragma optsize-
; 0000 013F CLKPR=0x80;
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 0140 CLKPR=0x00;
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 0141 #ifdef _OPTIMIZE_SIZE_
; 0000 0142 #pragma optsize+
; 0000 0143 #endif
; 0000 0144 
; 0000 0145 // Input/Output Ports initialization
; 0000 0146 // Port B initialization
; 0000 0147 // Func7=In Func6=In Func5=In Func4=Out Func3=Out Func2=Out Func1=Out Func0=In
; 0000 0148 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0149 PORTB=0x00;
	OUT  0x5,R30
; 0000 014A DDRB=0x1e;
	LDI  R30,LOW(30)
	OUT  0x4,R30
; 0000 014B 
; 0000 014C // Port C initialization
; 0000 014D // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 014E // State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 014F PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x8,R30
; 0000 0150 DDRC=0x00;
	OUT  0x7,R30
; 0000 0151 
; 0000 0152 // Port D initialization
; 0000 0153 // Func7=In Func6=Out Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0154 // State7=T State6=T State5=T State4=0 State3=T State2=T State1=T State0=T
; 0000 0155 PORTD=0x04;
	LDI  R30,LOW(4)
	OUT  0xB,R30
; 0000 0156 DDRD=0x60;
	LDI  R30,LOW(96)
	OUT  0xA,R30
; 0000 0157 
; 0000 0158 // Timer/Counter 0 initialization
; 0000 0159 // Clock source: System Clock
; 0000 015A // Clock value: 15,625 kHz
; 0000 015B // Mode: Normal top=0xFF
; 0000 015C // OC0A output: Disconnected
; 0000 015D // OC0B output: Disconnected
; 0000 015E TCCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 015F TCCR0B=0x05;
	LDI  R30,LOW(5)
	OUT  0x25,R30
; 0000 0160 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 0161 OCR0A=0x00;
	OUT  0x27,R30
; 0000 0162 OCR0B=0x00;
	OUT  0x28,R30
; 0000 0163 
; 0000 0164 // Timer/Counter 1 initialization
; 0000 0165 // Clock source: System Clock
; 0000 0166 // Clock value: Timer1 Stopped
; 0000 0167 // Mode: Normal top=0xFFFF
; 0000 0168 // OC1A output: Discon.
; 0000 0169 // OC1B output: Discon.
; 0000 016A // Noise Canceler: Off
; 0000 016B // Input Capture on Falling Edge
; 0000 016C // Timer1 Overflow Interrupt: Off
; 0000 016D // Input Capture Interrupt: Off
; 0000 016E // Compare A Match Interrupt: Off
; 0000 016F // Compare B Match Interrupt: Off
; 0000 0170 TCCR1A=0x00;
	STS  128,R30
; 0000 0171 TCCR1B=0x00;
	STS  129,R30
; 0000 0172 TCNT1H=0x00;
	STS  133,R30
; 0000 0173 TCNT1L=0x00;
	STS  132,R30
; 0000 0174 ICR1H=0x00;
	STS  135,R30
; 0000 0175 ICR1L=0x00;
	STS  134,R30
; 0000 0176 OCR1AH=0x00;
	STS  137,R30
; 0000 0177 OCR1AL=0x00;
	STS  136,R30
; 0000 0178 OCR1BH=0x00;
	STS  139,R30
; 0000 0179 OCR1BL=0x00;
	STS  138,R30
; 0000 017A 
; 0000 017B // Timer/Counter 2 initialization
; 0000 017C // Clock source: System Clock
; 0000 017D // Clock value: Timer2 Stopped
; 0000 017E // Mode: Normal top=0xFF
; 0000 017F // OC2A output: Disconnected
; 0000 0180 // OC2B output: Disconnected
; 0000 0181 ASSR=0x00;
	STS  182,R30
; 0000 0182 TCCR2A=0x00;
	STS  176,R30
; 0000 0183 TCCR2B=0x00;
	STS  177,R30
; 0000 0184 TCNT2=0x00;
	STS  178,R30
; 0000 0185 OCR2A=0x00;
	STS  179,R30
; 0000 0186 OCR2B=0x00;
	STS  180,R30
; 0000 0187 
; 0000 0188 // External Interrupt(s) initialization
; 0000 0189 // INT0: Off
; 0000 018A // INT1: Off
; 0000 018B // Interrupt on any change on pins PCINT0-7: Off
; 0000 018C // Interrupt on any change on pins PCINT8-14: Off
; 0000 018D // Interrupt on any change on pins PCINT16-23: Off
; 0000 018E EICRA=0x00;
	STS  105,R30
; 0000 018F EIMSK=0x00;
	OUT  0x1D,R30
; 0000 0190 PCICR=0x00;
	STS  104,R30
; 0000 0191 
; 0000 0192 // Timer/Counter 0 Interrupt(s) initialization
; 0000 0193 TIMSK0=0x01;
	LDI  R30,LOW(1)
	STS  110,R30
; 0000 0194 
; 0000 0195 // Timer/Counter 1 Interrupt(s) initialization
; 0000 0196 TIMSK1=0x00;
	LDI  R30,LOW(0)
	STS  111,R30
; 0000 0197 
; 0000 0198 // Timer/Counter 2 Interrupt(s) initialization
; 0000 0199 TIMSK2=0x00;
	STS  112,R30
; 0000 019A 
; 0000 019B // USART initialization
; 0000 019C // USART disabled
; 0000 019D UCSR0B=0x00;
	STS  193,R30
; 0000 019E 
; 0000 019F // Analog Comparator initialization
; 0000 01A0 // Analog Comparator: Off
; 0000 01A1 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 01A2 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 01A3 ADCSRB=0x00;
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 01A4 DIDR1=0x00;
	STS  127,R30
; 0000 01A5 
; 0000 01A6 // ADC initialization
; 0000 01A7 // ADC disabled
; 0000 01A8 ADMUX = 0x40;
	LDI  R30,LOW(64)
	STS  124,R30
; 0000 01A9 ADCSRA = 0x87;
	LDI  R30,LOW(135)
	STS  122,R30
; 0000 01AA 
; 0000 01AB // SPI initialization
; 0000 01AC // SPI disabled
; 0000 01AD SPCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x2C,R30
; 0000 01AE 
; 0000 01AF // TWI initialization
; 0000 01B0 // TWI disabled
; 0000 01B1 TWCR=0x00;
	STS  188,R30
; 0000 01B2 
; 0000 01B3 // TWI initialization
; 0000 01B4 // Mode: TWI Slave
; 0000 01B5 // Match Any Slave Address: Off
; 0000 01B6 // I2C Bus Slave Address: 0x00
; 0000 01B7 twi_slave_init(false, SLAVE_ADDRESS,twi_rx_buffer,sizeof(twi_rx_buffer),twi_tx_buffer,twi_rx_handler,twi_tx_handler);
	ST   -Y,R30
	LDI  R30,LOW(15)
	ST   -Y,R30
	LDI  R30,LOW(_twi_rx_buffer)
	LDI  R31,HIGH(_twi_rx_buffer)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDI  R30,LOW(_twi_tx_buffer)
	LDI  R31,HIGH(_twi_tx_buffer)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_twi_rx_handler)
	LDI  R31,HIGH(_twi_rx_handler)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_twi_tx_handler)
	LDI  R27,HIGH(_twi_tx_handler)
	RCALL _twi_slave_init
; 0000 01B8 
; 0000 01B9 Permit=0;
	CLR  R4
; 0000 01BA current=0;
	CLR  R7
	CLR  R8
; 0000 01BB voltage=0;
	CLR  R9
	CLR  R10
; 0000 01BC counter_digitizing = 0;
	CLR  R3
; 0000 01BD 
; 0000 01BE avarage_current = 0;
	CLR  R11
	CLR  R12
; 0000 01BF avarage_voltage = 0;
	CLR  R13
	CLR  R14
; 0000 01C0 status_power = 1;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 01C1 status_phone = 0;
	CBI  0x1E,1
; 0000 01C2 status_lock = 0;
	CBI  0x1E,2
; 0000 01C3 status_LED = 0;
	CBI  0x1E,3
; 0000 01C4 color_R = 0;
	LDI  R30,LOW(0)
	STS  _color_R,R30
; 0000 01C5 color_G = 0;
	STS  _color_G,R30
; 0000 01C6 color_B = 0;
	STS  _color_B,R30
; 0000 01C7 
; 0000 01C8 // Global enable interrupts
; 0000 01C9 #asm("sei")
	sei
; 0000 01CA 
; 0000 01CB while (1)
_0x7F:
; 0000 01CC       {
; 0000 01CD       b1=1;
	SBI  0x1E,0
; 0000 01CE       color_R = PORTB.3;
	LDI  R30,0
	SBIC 0x5,3
	LDI  R30,1
	STS  _color_R,R30
; 0000 01CF       color_G = PORTB.2;
	LDI  R30,0
	SBIC 0x5,2
	LDI  R30,1
	STS  _color_G,R30
; 0000 01D0       color_B = PORTB.1;
	LDI  R30,0
	SBIC 0x5,1
	LDI  R30,1
	STS  _color_B,R30
; 0000 01D1       status_LED = PORTD.6;
	SBIC 0xB,6
	RJMP _0x84
	CBI  0x1E,3
	RJMP _0x85
_0x84:
	SBI  0x1E,3
_0x85:
; 0000 01D2       status_lock = PIND.2;
	SBIC 0x9,2
	RJMP _0x86
	CBI  0x1E,2
	RJMP _0x87
_0x86:
	SBI  0x1E,2
_0x87:
; 0000 01D3 
; 0000 01D4       if (PORTB.4==1){
	SBIS 0x5,4
	RJMP _0x88
; 0000 01D5         Permit++;
	INC  R4
; 0000 01D6         if (Permit==10){
	LDI  R30,LOW(10)
	CP   R30,R4
	BRNE _0x89
; 0000 01D7             PORTB.4=0;
	CBI  0x5,4
; 0000 01D8             Permit=0;
	CLR  R4
; 0000 01D9         }
; 0000 01DA       }
_0x89:
; 0000 01DB       else
	RJMP _0x8C
_0x88:
; 0000 01DC         Permit=0;
	CLR  R4
; 0000 01DD 
; 0000 01DE       if(status_power == 0){
_0x8C:
	TST  R5
	BREQ PC+3
	JMP _0x8D
; 0000 01DF         ADMUX&=0xfe;
	LDS  R30,124
	ANDI R30,0xFE
	CALL SUBOPT_0xA
; 0000 01E0         ADCSRA|=0x40;
; 0000 01E1         while((ADCSRA&0x40)==0x40);
_0x8E:
	LDS  R30,122
	ANDI R30,LOW(0x40)
	CPI  R30,LOW(0x40)
	BREQ _0x8E
; 0000 01E2         current+=ADCW;
	LDS  R30,120
	LDS  R31,120+1
	__ADDWRR 7,8,30,31
; 0000 01E3 
; 0000 01E4         ADMUX|=0x01;
	LDS  R30,124
	ORI  R30,1
	CALL SUBOPT_0xA
; 0000 01E5         ADCSRA|=0x40;
; 0000 01E6         while((ADCSRA&0x40)==0x40);
_0x91:
	LDS  R30,122
	ANDI R30,LOW(0x40)
	CPI  R30,LOW(0x40)
	BREQ _0x91
; 0000 01E7         voltage+=ADCW;
	LDS  R30,120
	LDS  R31,120+1
	__ADDWRR 9,10,30,31
; 0000 01E8 
; 0000 01E9         counter_digitizing++;
	INC  R3
; 0000 01EA         if(counter_digitizing == 8){
	LDI  R30,LOW(8)
	CP   R30,R3
	BRNE _0x94
; 0000 01EB             avarage_current = current>>3;
	__GETW1R 7,8
	CALL __LSRW3
	__PUTW1R 11,12
; 0000 01EC             avarage_voltage = voltage>>3;
	__GETW1R 9,10
	CALL __LSRW3
	__PUTW1R 13,14
; 0000 01ED              if (avarage_current > RESTRICTIVE_CURRENT){
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CP   R30,R11
	CPC  R31,R12
	BRSH _0x95
; 0000 01EE                 PORTD.5 = 1;
	SBI  0xB,5
; 0000 01EF                 status_power = 2; // Error power
	LDI  R30,LOW(2)
	MOV  R5,R30
; 0000 01F0              }
; 0000 01F1              if (avarage_current > MIN_SUPPLY_CURRENT){
_0x95:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CP   R30,R11
	CPC  R31,R12
	BRSH _0x98
; 0000 01F2                 status_phone = 1;
	SBI  0x1E,1
; 0000 01F3              }else{
	RJMP _0x9B
_0x98:
; 0000 01F4                 status_phone = 0;
	CBI  0x1E,1
; 0000 01F5              }
_0x9B:
; 0000 01F6             counter_digitizing = 0;
	CLR  R3
; 0000 01F7             current = 0;
	CLR  R7
	CLR  R8
; 0000 01F8             voltage = 0;
	CLR  R9
	CLR  R10
; 0000 01F9         }
; 0000 01FA       }
_0x94:
; 0000 01FB 
; 0000 01FC       while(b1);
_0x8D:
_0x9E:
	SBIC 0x1E,0
	RJMP _0x9E
; 0000 01FD       }
	RJMP _0x7F
; 0000 01FE }
_0xA1:
	RJMP _0xA1
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.DSEG

	.CSEG
_twi_slave_init:
	ST   -Y,R27
	ST   -Y,R26
	SBI  0x1E,5
	LDI  R30,LOW(7)
	STS  _twi_result,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	STS  _twi_rx_buffer_G100,R30
	STS  _twi_rx_buffer_G100+1,R31
	LDD  R30,Y+6
	STS  _twi_rx_buffer_size_G100,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	STS  _twi_tx_buffer_G100,R30
	STS  _twi_tx_buffer_G100+1,R31
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	STS  _twi_slave_rx_handler_G100,R30
	STS  _twi_slave_rx_handler_G100+1,R31
	LD   R30,Y
	LDD  R31,Y+1
	STS  _twi_slave_tx_handler_G100,R30
	STS  _twi_slave_tx_handler_G100+1,R31
	IN   R30,0x8
	ORI  R30,LOW(0x30)
	OUT  0x8,R30
	LDD  R30,Y+10
	CPI  R30,0
	BREQ _0x200001E
	LDI  R30,LOW(1)
	RJMP _0x200007F
_0x200001E:
	LDD  R30,Y+9
	LSL  R30
_0x200007F:
	STS  186,R30
	LDS  R30,188
	ANDI R30,LOW(0x80)
	ORI  R30,LOW(0x45)
	STS  188,R30
	ADIW R28,11
	RET
_twi_int_handler:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	CALL __SAVELOCR6
	LDS  R17,_twi_rx_index
	LDS  R16,_twi_tx_index
	LDS  R19,_bytes_to_tx_G100
	LDS  R18,_twi_result
	MOV  R30,R17
	LDS  R26,_twi_rx_buffer_G100
	LDS  R27,_twi_rx_buffer_G100+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R20,R30
	LDS  R30,185
	ANDI R30,LOW(0xF8)
	CPI  R30,LOW(0x8)
	BRNE _0x2000023
	LDI  R18,LOW(0)
	RJMP _0x2000024
_0x2000023:
	CPI  R30,LOW(0x10)
	BRNE _0x2000025
_0x2000024:
	LDS  R30,_slave_address_G100
	RJMP _0x2000080
_0x2000025:
	CPI  R30,LOW(0x18)
	BREQ _0x2000029
	CPI  R30,LOW(0x28)
	BRNE _0x200002A
_0x2000029:
	CP   R16,R19
	BRSH _0x200002B
	MOV  R30,R16
	SUBI R16,-1
	LDS  R26,_twi_tx_buffer_G100
	LDS  R27,_twi_tx_buffer_G100+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
_0x2000080:
	STS  187,R30
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	STS  188,R30
	RJMP _0x200002C
_0x200002B:
	LDS  R30,_bytes_to_rx_G100
	CP   R17,R30
	BRSH _0x200002D
	LDS  R30,_slave_address_G100
	ORI  R30,1
	STS  _slave_address_G100,R30
	CBI  0x1E,4
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xA0)
	STS  188,R30
	RJMP _0x2000022
_0x200002D:
	RJMP _0x2000030
_0x200002C:
	RJMP _0x2000022
_0x200002A:
	CPI  R30,LOW(0x50)
	BRNE _0x2000031
	LDS  R30,187
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	RJMP _0x2000032
_0x2000031:
	CPI  R30,LOW(0x40)
	BRNE _0x2000033
_0x2000032:
	LDS  R30,_bytes_to_rx_G100
	SUBI R30,LOW(1)
	CP   R17,R30
	BRLO _0x2000034
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x2000081
_0x2000034:
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
_0x2000081:
	STS  188,R30
	RJMP _0x2000022
_0x2000033:
	CPI  R30,LOW(0x58)
	BRNE _0x2000036
	LDS  R30,187
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	RJMP _0x2000037
_0x2000036:
	CPI  R30,LOW(0x20)
	BRNE _0x2000038
_0x2000037:
	RJMP _0x2000039
_0x2000038:
	CPI  R30,LOW(0x30)
	BRNE _0x200003A
_0x2000039:
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x48)
	BRNE _0x200003C
_0x200003B:
	CPI  R18,0
	BRNE _0x200003D
	SBIS 0x1E,4
	RJMP _0x200003E
	CP   R16,R19
	BRLO _0x2000040
	RJMP _0x2000041
_0x200003E:
	LDS  R30,_bytes_to_rx_G100
	CP   R17,R30
	BRSH _0x2000042
_0x2000040:
	LDI  R18,LOW(4)
_0x2000042:
_0x2000041:
_0x200003D:
_0x2000030:
	RJMP _0x2000082
_0x200003C:
	CPI  R30,LOW(0x38)
	BRNE _0x2000045
	LDI  R18,LOW(2)
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x2000083
_0x2000045:
	CPI  R30,LOW(0x68)
	BREQ _0x2000048
	CPI  R30,LOW(0x78)
	BRNE _0x2000049
_0x2000048:
	LDI  R18,LOW(2)
	RJMP _0x200004A
_0x2000049:
	CPI  R30,LOW(0x60)
	BREQ _0x200004D
	CPI  R30,LOW(0x70)
	BRNE _0x200004E
_0x200004D:
	LDI  R18,LOW(0)
_0x200004A:
	LDI  R17,LOW(0)
	CBI  0x1E,4
	LDS  R30,_twi_rx_buffer_size_G100
	CPI  R30,0
	BRNE _0x2000051
	LDI  R18,LOW(1)
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x2000084
_0x2000051:
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
_0x2000084:
	STS  188,R30
	RJMP _0x2000022
_0x200004E:
	CPI  R30,LOW(0x80)
	BREQ _0x2000054
	CPI  R30,LOW(0x90)
	BRNE _0x2000055
_0x2000054:
	SBIS 0x1E,4
	RJMP _0x2000056
	LDI  R18,LOW(1)
	RJMP _0x2000057
_0x2000056:
	LDS  R30,187
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	LDS  R30,_twi_rx_buffer_size_G100
	CP   R17,R30
	BRSH _0x2000058
	LDS  R30,_twi_slave_rx_handler_G100
	LDS  R31,_twi_slave_rx_handler_G100+1
	SBIW R30,0
	BRNE _0x2000059
	LDI  R18,LOW(6)
	RJMP _0x2000057
_0x2000059:
	LDI  R26,LOW(0)
	__CALL1MN _twi_slave_rx_handler_G100,0
	CPI  R30,0
	BREQ _0x200005A
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	STS  188,R30
	RJMP _0x2000022
_0x200005A:
	RJMP _0x200005B
_0x2000058:
	SBI  0x1E,4
_0x200005B:
	RJMP _0x200005E
_0x2000055:
	CPI  R30,LOW(0x88)
	BRNE _0x200005F
_0x200005E:
	RJMP _0x2000060
_0x200005F:
	CPI  R30,LOW(0x98)
	BRNE _0x2000061
_0x2000060:
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	STS  188,R30
	RJMP _0x2000022
_0x2000061:
	CPI  R30,LOW(0xA0)
	BRNE _0x2000062
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	STS  188,R30
	SBI  0x1E,5
	LDS  R30,_twi_slave_rx_handler_G100
	LDS  R31,_twi_slave_rx_handler_G100+1
	SBIW R30,0
	BREQ _0x2000065
	LDI  R26,LOW(1)
	__CALL1MN _twi_slave_rx_handler_G100,0
	RJMP _0x2000066
_0x2000065:
	LDI  R18,LOW(6)
_0x2000066:
	RJMP _0x2000022
_0x2000062:
	CPI  R30,LOW(0xB0)
	BRNE _0x2000067
	LDI  R18,LOW(2)
	RJMP _0x2000068
_0x2000067:
	CPI  R30,LOW(0xA8)
	BRNE _0x2000069
_0x2000068:
	LDS  R30,_twi_slave_tx_handler_G100
	LDS  R31,_twi_slave_tx_handler_G100+1
	SBIW R30,0
	BREQ _0x200006A
	LDI  R26,LOW(0)
	__CALL1MN _twi_slave_tx_handler_G100,0
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x200006C
	LDI  R18,LOW(0)
	RJMP _0x200006D
_0x200006A:
_0x200006C:
	LDI  R18,LOW(6)
	RJMP _0x2000057
_0x200006D:
	LDI  R16,LOW(0)
	CBI  0x1E,4
	RJMP _0x2000070
_0x2000069:
	CPI  R30,LOW(0xB8)
	BRNE _0x2000071
_0x2000070:
	SBIS 0x1E,4
	RJMP _0x2000072
	LDI  R18,LOW(1)
	RJMP _0x2000057
_0x2000072:
	MOV  R30,R16
	SUBI R16,-1
	LDS  R26,_twi_tx_buffer_G100
	LDS  R27,_twi_tx_buffer_G100+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	STS  187,R30
	CP   R16,R19
	BRSH _0x2000073
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	RJMP _0x2000085
_0x2000073:
	SBI  0x1E,4
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
_0x2000085:
	STS  188,R30
	RJMP _0x2000022
_0x2000071:
	CPI  R30,LOW(0xC0)
	BREQ _0x2000078
	CPI  R30,LOW(0xC8)
	BRNE _0x2000079
_0x2000078:
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	STS  188,R30
	LDS  R30,_twi_slave_tx_handler_G100
	LDS  R31,_twi_slave_tx_handler_G100+1
	SBIW R30,0
	BREQ _0x200007A
	LDI  R26,LOW(1)
	__CALL1MN _twi_slave_tx_handler_G100,0
_0x200007A:
	RJMP _0x2000043
_0x2000079:
	CPI  R30,0
	BRNE _0x2000022
	LDI  R18,LOW(3)
_0x2000057:
_0x2000082:
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xD0)
_0x2000083:
	STS  188,R30
_0x2000043:
	SBI  0x1E,5
_0x2000022:
	STS  _twi_rx_index,R17
	STS  _twi_tx_index,R16
	STS  _twi_result,R18
	STS  _bytes_to_tx_G100,R19
	CALL __LOADLOCR6
	ADIW R28,6
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI

	.CSEG

	.DSEG
_twi_tx_index:
	.BYTE 0x1
_twi_rx_index:
	.BYTE 0x1
_twi_result:
	.BYTE 0x1
_read_command:
	.BYTE 0x1
_current_command:
	.BYTE 0x1
_i:
	.BYTE 0x1
_size_commands:
	.BYTE 0x1
_write_command:
	.BYTE 0x1
_color_R:
	.BYTE 0x1
_color_G:
	.BYTE 0x1
_color_B:
	.BYTE 0x1
_twi_rx_buffer:
	.BYTE 0xD
_twi_tx_buffer:
	.BYTE 0x15
_slave_address_G100:
	.BYTE 0x1
_twi_tx_buffer_G100:
	.BYTE 0x2
_bytes_to_tx_G100:
	.BYTE 0x1
_twi_rx_buffer_G100:
	.BYTE 0x2
_bytes_to_rx_G100:
	.BYTE 0x1
_twi_rx_buffer_size_G100:
	.BYTE 0x1
_twi_slave_rx_handler_G100:
	.BYTE 0x2
_twi_slave_tx_handler_G100:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x0:
	LDS  R30,_twi_rx_buffer
	LDI  R31,0
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1:
	LDS  R26,_i
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x2:
	LDS  R30,_i
	LDI  R31,0
	SUBI R30,LOW(-_twi_rx_buffer)
	SBCI R31,HIGH(-_twi_rx_buffer)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x3:
	LDS  R30,_i
	SUBI R30,-LOW(1)
	STS  _i,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDS  R30,_current_command
	LDI  R31,0
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x6:
	LDS  R30,_i
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	LDS  R30,_size_commands
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LDS  R30,_write_command
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x9:
	LDS  R26,_i
	LDI  R27,0
	SUBI R26,LOW(-_twi_tx_buffer)
	SBCI R27,HIGH(-_twi_tx_buffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	STS  124,R30
	LDS  R30,122
	ORI  R30,0x40
	STS  122,R30
	RET


	.CSEG
__LSRW3:
	LSR  R31
	ROR  R30
__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__LTB12U:
	CP   R26,R30
	LDI  R30,1
	BRLO __LTB12U1
	CLR  R30
__LTB12U1:
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
