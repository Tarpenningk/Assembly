.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

;Includes
INCLUDE debug.h         
INCLUDE fallout.h
;INCLUDE print_array.h

;Globals
;Told to have these in from assignment.
;Maximum number of strings, where one of them is the password
MAX_NUM EQU 25
;Maximum length of each password string
MAX_LEN EQU 14

.STACK  4096
.DATA                   

;DWORD Variables

;WORD Variables
;Size for the array
sz WORD ?                  
length_of_password_string WORD ?
;Keeping track of an index to match the guess with actual password
array_index_for_string WORD ?
;To know if the password is found, this is the character matches in the strings.
number_of_matches WORD ?

;BYTE Variables
size_of_array BYTE   6 DUP (?), 0
temp_string BYTE   MAX_LEN DUP (?)
array_string BYTE   (MAX_NUM + 1) * MAX_LEN DUP (?)

;Prompt Variables
prompt_for_string BYTE   "Enter a string: ", 0
prompt_for_index BYTE   "Enter the index for the test password (1-based): ", 0
prompt_for_matches BYTE   "Enter the number of exact character matches: ", 0
prompt_num_strings_entered BYTE   "The number of strings entered is ",0

.CODE    
;Macros
;Can't get including print.h to work
printIt MACRO array, size
LOCAL loopIt
lea ebx, array
mov ecx, 0
mov cx, size
loopIt:
output [ebx]
output carriage
;Moves to next string in the array
add ebx, MAX_LEN
loop loopIt
ENDM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                                  
fillIt MACRO array, str, index
push eax
push ecx
push edx
lea edi, array
mov eax, 0
mov ax, index
mov ecx, MAX_LEN
mul ecx
add edi, eax
lea esi, str
mov ecx, MAX_LEN
cld
rep movsb
pop edx
pop ecx
pop eax
ENDM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Had problems with start_ 
_start PROC
mov length_of_password_string, MAX_LEN
mov sz, 0
lea ebx, array_string

whileLoop:
cmp sz, MAX_NUM

jae endWhileLoop

;Why does this act wierd the second go through?!
output prompt_for_string
input temp_string, MAX_LEN
output temp_string
output carriage
lea ebx, temp_string
mov cl, BYTE PTR [ebx]
;Have to check if end of inputting strings
cmp cl, "x" 
; End loop if x is found
je endWhileLoop

fillIt array_string, temp_string, sz

inc sz
jmp whileLoop

endWhileLoop:
output carriage
output prompt_num_strings_entered
outputW sz
output size_of_array
output carriage
cmp sz, 0
je done

whileNeedingToLoopStill:

;Coding convention 
cmp sz, 1
jle endWhileNeedingToLoopStill

printIt array_string, sz

output prompt_for_index
input temp_string, MAX_LEN
output temp_string
atoi temp_string
output carriage
mov array_index_for_string, ax
output prompt_for_matches
input temp_string, MAX_LEN
output temp_string
atoi temp_string
output carriage
mov number_of_matches, ax

fallouthacking array_string, length_of_password_string, sz, array_index_for_string, number_of_matches

output carriage
mov sz, ax
jmp whileNeedingToLoopStill

endWhileNeedingToLoopStill:

cmp sz, 1
jne done

printIt array_string, sz
output carriage;
;;;;;;;;;;;;;;;;;;;;;;;;;
done:
INVOKE  ExitProcess, 0
_start ENDP
PUBLIC _start
END