.386
.MODEL FLAT

INCLUDE debug.h
INCLUDE float.h
INCLUDE sort_points.h
INCLUDE io.h

PUBLIC b   ;procedure name

.CODE

;Variables
points_array_address EQU [ebp+14]
number_of_points EQU [ebp+12]
hi EQU [ebp+10]
lo EQU [ebp+8]
temp_recursive_result_one EQU [ebp-4]
temp_recursive_result_two EQU [ebp-8]

b    PROC   NEAR32

push ebp
mov ebp, esp
sub esp, 8
push ebx
push ecx
push edx
pushf
mov bx, hi
mov cx, lo
cmp bx, cx

je base ; hi = lo Base Case Found!

inc cx
pushd points_array_address
pushw number_of_points
push bx
push cx

call b

mov temp_recursive_result_one, eax
dec cx
dec bx
pushd points_array_address
pushw number_of_points
push bx
push cx

call b

mov temp_recursive_result_two, eax
fld REAL4 PTR temp_recursive_result_one
fld REAL4 PTR temp_recursive_result_two
fsubr
mov ebx, points_array_address
;Getting first coordinate 
mov eax, 0
mov ax, hi
add ax, ax
mov cx, 4
mul cx
add ebx, eax
mov eax, [ebx]
mov temp_recursive_result_one, eax
fld REAL4 PTR temp_recursive_result_one
mov ebx, points_array_address
;Getting the second coordinate - esentially same process as first
mov eax, 0
mov ax, lo
add ax, ax
mov cx, 4
mul cx
add ebx, eax
mov eax, [ebx]
mov temp_recursive_result_one, eax
fld REAL4 PTR temp_recursive_result_one
fsubr
fdiv
fstp REAL4 PTR temp_recursive_result_one
mov eax, temp_recursive_result_one
jmp done

base:

mov eax, 0
mov ax, cx
add ax, ax
mov cx, 4
mul cx
mov ebx, points_array_address
add ebx, eax
add ebx, 4
mov eax, [ebx]

done:

popf
pop edx
pop ecx
pop ebx
mov esp, ebp
pop ebp
ret 10

b   ENDP

END
