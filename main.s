.syntax unified

.word 0x20000100
.word _start

.global _start
.type _start, %function
_start:
	//mov
	mov r1,#1
	mov r2,#2
	mov r3,#3
	mov r4,r1

	//push
	push {r1,r2,r3,r4}
	

	//pop
	pop {r5,r6,r7}

	mov r5,#0
	mov r6,#0
	mov r7,#0

	push {r1,r4,r3,r2}

	pop {r7,r6,r5}
	b label01
label01:
	nop

	//
	//branch w/ link
	//
	bl	sleep

sleep:
	nop
	b       sleep
