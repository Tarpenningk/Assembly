.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

CR EQU 0Dh
LF EQU 0Ah

INCLUDE debug.h
INCLUDE float.h
INCLUDE sort_points.h
INCLUDE io.h

MAX_NUM_POINTS EQU 20 ;Said won't be given more than 20 points 

.STACK 4096

.DATA

points_array DWORD 2*MAX_NUM_POINTS DUP (?) ;Array of points
result DWORD ?

x_val REAL4 ?
Tolerance REAL4 0.00001

num_items_in_array WORD ?
degree WORD ?

;Asks for variables
prompt1 BYTE "Enter the x-coordinate of the desired interpolated y.", 0
prompt2 BYTE "Enter the degree of the interpolating polynomial.", 0

;Instructions 
prompt3 BYTE "You may enter up to 20 points, one at a time.", CR, LF
prompt4 BYTE "Input q to quit", 0

;Result
result_prompt BYTE "The result is:", 0
.CODE

EXTRN interpolate : NEAR32 ;Check interpolate.asm 

;Code Starts Here

_start:

output prompt1 ;Asks for x_coor of desired y
output carriage 
input text, 8 ;Double-check this is correct number. Tried: 10
output text
output carriage
;first part done
atof text, x_val ;Converts the text to a float and stores it into x_val
output prompt2 ;Asks for degree 
output carriage
input text, 8
output text
output carriage
;second part done
atoi text
mov degree, ax
output prompt3 ; Shows first half of directions
output carriage
output prompt4 ; Second half of directions
output carriage
mov num_items_in_array, 0
lea ebx, points_array

repeatIt:
cmp num_items_in_array, MAX_NUM_POINTS
jae endRepeatIt
input text, 8
output text
output carriage
cmp text, "q" ; Repeat until q is entered, can do it directly
je endRepeatIt
atof text, result
mov eax, result
mov DWORD PTR [ebx], eax ;Stores result into the array
add ebx, 4; Moves to next location in the array
input text, 8
output text
output carriage
atof text, result
mov eax, result
mov DWORD PTR [ebx], eax
inc num_items_in_array ;Coefficients were entered, increase number of elements in array
add ebx, 4 ;Moves to next location in the array

jmp repeatIt ;q hasn't been entered, time to put in more elements!

endRepeatIt:

sort_points points_array, x_val, Tolerance, num_items_in_array ;sort_points was given to us, look for it in include if need be
output carriage
print_points points_array, num_items_in_array ;print_points is in sort_points.h
output carriage
lea ebx, points_array
push x_val
push ebx
push num_items_in_array
push degree

call interpolate ; interpolate.asm

output result_prompt
mov result, eax
ftoa result, WORD PTR 5, WORD PTR 8, text
output text
output carriage
output carriage

done:

INVOKE ExitProcess, 0
PUBLIC _start
END