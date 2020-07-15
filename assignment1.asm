section .data
arr dd 0xABCDEF21 , 0x1BCD1234 , 0x1234567, 0x3, 0x12
msg1 db "Total positive numbers="
len1 equ $-msg1
msg2 db 0xA , "Total negative numbers="
len2 equ $-msg2

section .bss
cnt resb 2
pos_cnt resb 2
neg_cnt resb 2

section .text
global _start
_start:
mov byte[cnt], 05h
mov byte[pos_cnt], 00h
mov byte[neg_cnt], 00h

mov esi, arr
 
l3:
mov eax, dword[esi]
add eax, 00h
js l1

inc byte[pos_cnt]
jmp l2

l1:
inc byte[neg_cnt]

l2:
add esi,4
dec byte[cnt]
jnz l3



last:
mov al, byte[pos_cnt]
add al,30h
mov byte[pos_cnt],al

mov al, byte[neg_cnt]
add al,30h
mov byte[neg_cnt],al

mov eax,4
mov ebx,1
mov ecx,msg1
mov edx,len1 
int 80h    
	
mov eax,4
mov ebx,1
mov ecx,pos_cnt
mov edx,1
int 80h

 mov eax,4
mov ebx,1
mov ecx,msg2
mov edx,len2
int 80h    

mov eax,4
mov ebx,1
mov ecx,neg_cnt
mov edx,1
int 80h

 mov eax,1
mov ebx,0
int 80h
