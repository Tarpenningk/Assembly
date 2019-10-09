.386
.MODEL FLAT
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE io.h
INCLUDE debug.h

CR EQU 0Dh
LF EQU 0Ah

.STACK 4096

.DATA ; reserve space for storage.


orig_addr DWORD ? ;address of index 1 of original
mod_addr DWORD ? ;address of index 1 of modified
dmatend DWORD ?;matend

og_matrix WORD 400 DUP (?) ;original game board
mod_matrix WORD 400 DUP (?) ;modified game board

x_size WORD ?
y_size WORD ?
matsize WORD ?
rowjump WORD ?
rowcount WORD ?
colcount WORD ?
pathoutcount WORD ?

counter WORD ?

temp_loop WORD ?


DOWN WORD ?
RIGHT WORD ?
tmpcol WORD ?
tmprow WORD ?
sprlprctr WORD ? ;SuperLooperCounter
looptmp WORD ?

offsetLargest WORD ?

tempMatVal WORD ?

shiftvar WORD ?
TEMP WORD ?
newvalue WORD ?
newval1 WORD ?
newval2 WORD ?


values WORD ?

valuesbuffed WORD ?

buffer_2 WORD ?

buffer_3 WORD ?

;Matrix End - LAST LOCATION IN THE MATRIX
matend WORD ?

rstr BYTE "r", 0
dstr BYTE "d", 0
prompt1 BYTE "Enter number of rows in Vankin's Grid:", 0
prompt2 BYTE "Enter number of columns in Vankin's Grid:", 0
prompt3 BYTE "Enter a value for cell of grid:", 0
testout BYTE "Dimension: ", 0
outtest1 BYTE "Matrix Size: ",0
string1 BYTE 500 DUP (?), 0
tempString BYTE 6 DUP (?), 0
tempout BYTE 6 DUP (?), 0
pathout BYTE 20 DUP (?), 0




.CODE

;inputs into values
input1_macro      MACRO prompt, Val, str
output prompt
input str, 8
atoi str
mov Val, ax

itoa values, Val
output values
output carriage

ENDM

;input the values into an address
input2_macro                  MACRO prompt, str
output prompt
input str, 8
atoi str

itoa values, ax
output values
mov [ebx], ax

ENDM

;outputs the original matrix
output_macro                  MACRO
lea ebx, og_matrix
mov cx, 0
outloop1:
mov dx, 0
outloop2:
itoa tempout, [ebx]
output tempout
add ebx, 2
inc dx
cmp dx, colcount
jne outloop2
output carriage
inc cx
cmp cx, rowcount
jne outloop1
ENDM

;outputs the modified matrix
output2_macro                  MACRO
output carriage
output carriage
lea edx, mod_matrix
mov cx, 0
outloop3:
mov bx, 0
outloop4:
itoa tempout, [edx]
output tempout
add edx, 2
inc bx
cmp bx, colcount
jne outloop4
output carriage
inc cx
cmp cx, rowcount
jne outloop3
ENDM

;Modified Matrx
new_matrix_macro         MACRO

mov cx, matend
sub cx, 2

begin:
lea ebx, og_matrix
lea edx, mod_matrix
add bx, cx
add dx, cx

sub ebx, 2

mov ax, 0
mov counter, ax

mov temp_loop, 0

a_loop:
mov ax, temp_loop
add ax, tmpcol
mov temp_loop, ax 
cmp ax, cx
je not_standard
mov ax, counter
add ax, 1
mov counter, ax
cmp ax, rowcount
jne a_loop

standard_right:  ;Not on right hand edge
mov ax, [ebx]
add ax, [edx]
mov RIGHT, ax
jmp skip_not_standard

not_standard: ;On right hand edge
mov ax, 0
mov ax, [ebx]
mov RIGHT, ax

skip_not_standard:
sub edx, 2
add dx, tmpcol
mov ax, [ebx]
add ax, [edx]
mov DOWN, ax
sub dx, tmpcol
mov ax, DOWN
cmp ax, RIGHT
jg down_value

right_value: 
mov ax, RIGHT
mov [edx], ax
jmp skip_down_value

down_value:
mov ax, DOWN
mov [edx], ax

skip_down_value:
sub cx, 2
cmp cx, 0
jne begin
ENDM

set_to_last_macro MACRO
mov cx, matend

filledmodify: 
lea ebx, og_matrix

lea edx, mod_matrix

sub cx, 2
add bx, cx
add dx, cx
mov ax, [ebx]
mov [edx], ax


cmp cx, 0
jne filledmodify
ENDM



_start:

input1_macro prompt1, x_size, values
input1_macro prompt2, y_size, values

lea ebx, og_matrix
mov ax, y_size
mov rowcount, ax
mov dx, x_size
mov colcount, dx
mul x_size
mov matsize, ax
mov ax, matsize
mov dx, 2
mul dx
mov matend, ax

;MATRIX SIZE TEST START      { SHOWS SIZE OF MATRIX  }
;output outtest1
;itoa outputtest, ax       ;TO BE DELETED FOR FINAL PRODUCT25
;output outputtest
;output carriage
;MATRIX SIZE TEST END

;Loads the first matrix
mov dx, 0
inputLoop:
input2_macro prompt3, values
add ebx, 2
output carriage
inc dx
cmp dx, matsize
jne inputLoop
;end matrix load 1

output_macro ; output first matrix

mov ax, 2
mul colcount

mov tmpcol, ax
mov ax, colcount

;output testout
set_to_last_macro
;output testout
new_matrix_macro
;output testout
output2_macro


            INVOKE ExitProcess, 0
PUBLIC _start
            END
