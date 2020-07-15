section .data
arr dd 11100022h,95857234h,12345678h,9BCD1234h,0xCDEF4567,0h,0h,0h,0h
arr1 dd 00h,00h,00h,00h,00h
arr2 dd 95857234h,12345678h,9BCD1234h,0xCDEF4567,11100022h,0h,0h,0h,0h
arr3 dd 00h,00h,00h,00h,00h
msg1 db "after non overlapping block transfer-"
len1 equ $-msg1
msg2 db "after overlapping block transfer- "
len2 equ $-msg2
msg3 db "after non overlapping block transfer using string instructions -"
len3 equ $-msg3
msg4 db "after overlapping block transfer using string instructions -"
len4 equ $-msg4
msg5 db "for string instructions"
len5 equ $-msg5

newline db 10
dash db '-'
count db 5

section .bss
cnt resb 2
display resb 8
blockno resb 2
;----------------for printing any msg---------------------
	%macro print 2   	
	mov eax,4
	mov ebx,1
	mov ecx,%1
	mov edx,%2
	int 80h
	%endmacro

;--------------for input data---------------------------

        %macro read 2   	
	mov eax,3
	mov ebx,0
	mov ecx,%1
	mov edx,%2
	int 80h
	%endmacro

;-------------------------------------------------------



section .text
global _start

_start:

	
;---------------for printing first array data with address---------------------	
	mov esi,arr
	
	up1:
	
	mov eax,esi
	call hta
	
	print dash,1
	
	
	mov eax,dword[esi]
	call hta
	
	print newline,1
	
	add esi,4
	dec byte[count]
	jnz up1

;----------------non overlapping block transfer-------------------	
	
	mov byte[count],05h
		
	mov esi,arr
	mov edi,arr1
	
	copy:
	mov eax,dword[esi]
	mov dword[edi],eax
	
	add esi,4
	add edi,4
	dec byte[count]
	jnz copy
	
	
	
	

;----------printing second array after copying data(NOBlockT)-----------------	

	print msg1,len1
	print newline,1
	
	mov byte[count],05h
	mov esi,arr1
	
	up2:
	
	mov eax,esi
	call hta
	
	print dash,1
	
	
	mov eax,dword[esi]
	call hta
	
	print newline,1
	
	add esi,4
	dec byte[count]
	jnz up2
	
;-----------------overlapping block transfer------------------------------	
	
	mov byte[count],05h
	mov esi,arr+16
	mov edi,esi
	mov eax,12
	add edi,eax
	
	up3:
	mov eax,dword[esi]
	mov dword[edi],eax
	sub esi,4
	sub edi,4
	dec byte[count]
	jnz up3



;----------------------printing array after overlapping block transfer--------------
	
	
	print msg2,len2
	print newline,1
	
	mov byte[count],05h
	mov esi,arr+12
	
	up4:
	mov eax,esi
	call hta
	
	print dash,1
	
	
	mov eax,dword[esi]
	call hta
	
	print newline,1
	
	add esi,4
	dec byte[count]
	jnz up4
	
	
	

;------------non overlapping with string instructions (initial array)----------------------------	

	print msg5,len5
	print newline,1
	
		
	mov byte[count],05h
	mov esi,arr2
	
	up7:
	
	mov eax,esi
	call hta
	
	print dash,1
	
	
	mov eax,dword[esi]
	call hta
	
	print newline,1
	
	add esi,4
	dec byte[count]
	jnz up7

;--------------non overlapping with string instructions ----------------------------	
	
	mov ecx,05h
	mov esi, arr2
	mov edi, arr3
	rep movsd
	

	print msg3,len3
	print newline,1
	
	mov byte[count],05h
	mov esi,arr3
	
	up5:
	
	mov eax,esi
	call hta
	
	print dash,1
	
	
	mov eax,dword[esi]
	call hta
	
	print newline,1
	
	add esi,4
	dec byte[count]
	jnz up5

;---------------------------- overlapping with string instructions --------------------------------	
	
	mov ecx,5h
	std
	mov esi,arr2+16
	mov edi,arr2+28
	rep movsd
	
	
	print msg4,len4
	print newline,1
	
	mov byte[count],05h
	
	mov esi,arr2+12
	
	up6:
	
	mov eax,esi
	call hta
	
	print dash,1
	
	
	mov eax,dword[esi]
	call hta
	
	print newline,1
	
	add esi,4
	dec byte[count]
	jnz up6

	
;--------------------------------------------------------------------------		
	
	mov eax,1
	mov ebx,0
	int 80h

;-------------------------------------------------------------------------
	
;------------------hex to ascii conversion and display--------------------
	
	hta:
	mov edi,display
	mov byte[cnt],08h
	
	l1:
	rol eax,4
	mov bl,al
	and bl,0Fh
	cmp bl,9h
	jbe l2
	add bl,7h
	
	l2:
	add bl,30h
	mov byte[edi],bl

	inc edi
	dec byte[cnt]
	jnz l1
	
	print display,8

	
	ret
	
;-----------------------THE END------------------------------:)	
