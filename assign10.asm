;----------------------------------
;            macro to read
;-----------------------------------
%macro read 2
mov rax, 00h
mov rdi, 01
mov rsi, %1
mov rdx, %2
syscall
%endmacro
;-------------------------------------

;----------------------------------
;            macro to display
;-----------------------------------
%macro display 2
mov rax, 01h
mov rdi, 01
mov rsi, %1
mov rdx, %2
syscall
%endmacro
;-------------------------------------


;----------------------------------
;            macro to printf
;-----------------------------------
%macro mprintf 1
mov rdi, formatpf
sub rsp,8
movsd xmm0,[%1]
mov rax, 1
call printf
add rsp,8
%endmacro
;-------------------------------------


;----------------------------------
;            macro to scanf
;-----------------------------------
%macro mscanf 1
mov rdi, formatsf
mov rax,0
sub rsp,8
mov rsi,rsp
call scanf
mov r8,qword[rsp]
mov qword[%1],r8
add rsp,8
%endmacro
;-------------------------------------


;----------------------------------
;            macro to printf2
;-----------------------------------
%macro mprintf2 3
mov rdi, %3
sub rsp,8
movsd xmm0,[%1]
movsd xmm1,[%2]
mov rax, 2
call printf
add rsp,8
%endmacro
;-------------------------------------


section .data
msg1 db "The entered value is : "
newline db 10,13 
note db "Enter the coefficients of the quadratic equation",10,13		;50
a_var db "Enter a : ",10,13                      ;12
b_var db "Enter b : ",10,13 
c_var db "Enter c : ",10,13 
msg3 db "The first root is : "               ;20
msg4 db "The second root is : "               ;21

pos db "The roots are real",10,13		;20
nega db "The roots are imaginary",10,13		;25

formatpf db "%lf",10,0
df1 db "%lf + %lf i",10,0
df2 db "%lf - %lf i",10,0
formatsf db "%lf",0

four dq 4
two dq 2 
minus dq -1



section .bss
count resb 1



buffer resb 100



a resq 1
b resq 1
c resq 1

b2 resq 1
delta resq 1
temp resq 1
temp2 resq 1
root1 resq 1
root2 resq 1





section .text
extern printf
extern scanf


global main
main:
display note,50

display a_var,12
mscanf a
display msg1,23
mprintf a

display b_var,12
mscanf b
display msg1,23
mprintf b

display c_var,12
mscanf c
display msg1,23
mprintf c

;---------------------------------------calculating the roots
 
fld qword[b]
fmul qword[b]
fstp qword[b2]
fild qword[four]
fmul qword[a]
fmul qword[c]
fstp qword[temp]
;--------------------------------mprintf temp
 fld qword[b2]
fsub qword[temp]
fstp qword[delta]

btr qword[delta],63	;btr=check and reset
jc imag_part
jmp real_part



real_part:
display pos,20
fild qword[minus]
fmul qword[b]
fstp qword[b]
fld qword[delta]
fsqrt
fstp qword[b2]
fld qword[b2]
fadd qword[b]
fstp qword[temp2]

fild qword[two]
fmul qword[a]
fstp qword[temp]
;---------------------------------mprintf temp
fld qword[temp2]
fdiv qword[temp]
fstp qword[root1]
display msg3,20
mprintf root1


;---------------------root2
fld qword[b]
fsub qword[b2]
fdiv qword[temp]
fstp qword[root2]
display msg4,21
mprintf root2



jmp exit







imag_part:
display nega,25

fild qword[minus]
fmul qword[b]
fstp qword[b] 

fld qword[delta]
fsqrt
fstp qword[b2]

fild qword[two]
fmul qword[a]
fstp qword[temp]
fld qword[b]
fdiv qword[temp]
fstp qword[b]
fld qword[b2]
fdiv qword[temp]
fstp qword[b2]
mprintf2 b,b2,df1
mprintf2 b,b2,df2






jmp exit

;-----------------------------------mprintf delta

b1:



exit:
mov rax,60
mov rdi,00
syscall



