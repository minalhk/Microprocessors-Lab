section .data

	msg1 db "Offset : "
	len1 equ $-msg1
	msg2 db "Base Address : "
	len2 equ $-msg2
	msg3 db "----------------GDT----------------"
	len3 equ $-msg3
	msg4 db "----------------LDT----------------"
	len4 equ $-msg4
	msg5 db "----------------IDT----------------"
	len5 equ $-msg5
	msg6 db "----------------MSW----------------"
	len6 equ $-msg6
	msg7 db "----------------TR-----------------"
	len7 equ $-msg7
	
	msg8 db "You are in Protectd Mode"
	len8 equ $-msg8
	
	newline db 10

section .bss
	g resb 06h
	l resb 06h
	i resb 06h
	m resb 06h
	t resb 06h
	final resb 8h

%macro print 2				
	mov eax, 4
	mov ebx, 0
	mov ecx, %1
	mov edx, %2
	int 80h
%endmacro


section .text
	global _start

	_start:


		;-------------------------------------------------------------
		print msg3,len3
		print newline,1

		sgdt [g]



		print msg1,len1 ;offset msg
		mov ax,word[g]
		mov ecx,04h
		mov esi,final
		call _convertHexToASCII
		print final,4

		print newline,1

		print msg2,len2 	;base address msg
		mov ax,word[g+5]
		mov ecx,04h
		mov esi,final
		call _convertHexToASCII
		print final,4

		mov ax,word[g+3]
		mov ecx,04h
		mov esi,final
		call _convertHexToASCII
		print final,4

		;------------------------------------------------------------

		print newline,1

		print msg4,len4
		print newline,1

		sldt [l]

		mov ax,word[l]
		mov ecx,04h
		mov esi,final
		call _convertHexToASCII
		print final,4

		;-------------------------------------------------------------

		print newline,1

		print msg5,len5
		print newline,1

		sidt [i]

		
		print msg1,len1
		mov ax,word[i]
		mov ecx,04h
		mov esi,final
		call _convertHexToASCII
		print final,4

		print newline,1

		print msg2,len2
		mov ax,word[i+5]
		mov ecx,04h
		mov esi,final
		call _convertHexToASCII
		print final,4

		mov ax,word[i+3]
		mov ecx,04h
		mov esi,final
		call _convertHexToASCII
		print final,4

		;-----------------------------------------------------------

		print newline,1

		print msg6,len6
		print newline,1

		smsw [m]

		mov ax,word[m]
		mov ecx,04h
		mov esi,final
		call _convertHexToASCII
		print final,4

		;------------------------------------------------------------

		print newline,1

		print msg7,len7
		print newline,1

		str [t]

		mov ax,word[t]
		mov ecx,04h
		mov esi,final
		call _convertHexToASCII
		print final,4
		
		
		mov ax,word[m]
		bt ax,0
		jnc exit5

		print newline,1
		print msg8,len8

exit5:mov eax, 1
mov ebx, 0
int 80h





_convertHexToASCII:
Repeat:
	rol ax, 4
	mov bl, al
	and bl, 0x0F
	cmp bl, 09h
	jbe addThirty
	add bl, 07h
addThirty:
	add bl, 30h

	mov byte[esi], bl
	inc esi
	dec ecx
	jnz Repeat
	ret
