.386
.MODEL FLAT

INCLUDE debug.h
INCLUDE float.h
INCLUDE sort_points.h
INCLUDE io.h

PUBLIC interpolate

CR EQU 0Dh
LF EQU 0Ah

.CODE

EXTRN b : NEAR32

;Variables 
interpolated_x EQU [ebp+16]
points_array_address EQU [ebp+12]
number_of_points EQU [ebp+10]
degree EQU [ebp+8]
first_result EQU [ebp-4]
second_result EQU [ebp-8]
x_coordinate EQU [ebp-12]
first_counter EQU [ebp-14]
second_counter EQU [ebp-16]

interpolate PROC NEAR32
push ebp
mov ebp, esp
sub esp, 16
push ebx
push ecx
push edx
pushfd ; Or pushf? 
mov eax, 0
fldz
fstp REAL4 PTR first_result
mov cx, 0
loopIt:
cmp cx, degree
jg done
pushd points_array_address
pushw number_of_points
push cx
pushw 0
call b
mov second_result, eax
fld REAL4 PTR second_result
mov dx, 0
loopItIn:
cmp cx, dx
je endLoopItIn
mov first_counter, cx
mov second_counter, dx
mov ebx, points_array_address ;Gets next x_coordinate. X sub 0, x sub 1, ...
mov eax, 0
mov ax, dx
add ax, ax
add ax, ax
add ax, ax
add ebx, eax
mov eax, [ebx]
mov x_coordinate, eax

fld REAL4 PTR x_coordinate
fld REAL4 PTR interpolated_x
fsubr
fmul
mov cx, first_counter
mov dx, second_counter
inc dx
jmp loopItIn
endLoopItIn:
fld REAL4 PTR first_result
fadd
fstp REAL4 PTR first_result
inc cx
jmp loopIt
done:
mov eax, first_result
popfd
pop edx
pop ecx
pop ebx
mov esp, ebp
pop ebp
ret 12

interpolate ENDP
END
