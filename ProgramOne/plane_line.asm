.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE io.h
INCLUDE debug.h
INCLUDE sqrt.h

;Carriage return and line feed
CR EQU 0Dh
LF EQU 0Ah

.STACK  4096

.DATA

;Used for Cross Product
first_component WORD ?
second_component WORD ?
third_component WORD ?

;Plane One Coordinates
x1_plane WORD ?
y1_plane WORD ?
z1_plane WORD ?

;Plane Two Coordinates
x2_plane WORD ?
y2_plane WORD ?
z2_plane WORD ?

;Plane Three Coordinates
x3_plane WORD ?
y3_plane WORD ?
z3_plane WORD ?

;Line One Coordinates
x1_line WORD ?
y1_line WORD ?
z1_line WORD ?

;Line Two Coordinates
x2_line WORD ?
y2_line WORD ?
z2_line WORD ?

;The Normal
normal_to_the_plane WORD ?

;Variables needed for calculating the normal_to_the_plane
point_subtraction_x1 WORD ?
point_subtraction_y1 WORD ?
point_subtraction_z1 WORD ?

point_subtraction_x2 WORD ?
point_subtraction_y2 WORD ?
point_subtraction_z2 WORD ?

;Dot Product Variables
dot_product_component_x1 WORD ? 
dot_product_component_y1 WORD ?
dot_product_component_z1 WORD ?

dot_product_component_x2 WORD ?
dot_product_component_y2 WORD ? 
dot_product_component_z2 WORD ?

dot_product_result1 WORD ? 
dot_product_result2 WORD ?

;Final Values
final_x WORD ?
final_y WORD ?
final_z WORD ?

;Final Decimals
final_decimal_x WORD ?
final_decimal_y WORD ?
final_decimal_z WORD ?

;Variables needed for Parametric Equation
pe_x1 WORD ?
pe_y1 WORD ?
pe_z1 WORD ?

pe_x2 WORD ?
pe_y2 WORD ? 
pe_z2 WORD ?

pe_x3 WORD ? 
pe_y3 WORD ?
pe_z3 WORD ?

;Put Words Before Bytes

promptx1_plane BYTE "Enter the x-coordinate of the first point on the plane:", 0 
prompty1_plane BYTE "Enter the y-coordinate of the first point on the plane:", 0
promptz1_plane BYTE "Enter the z-coordinate of the first point on the plane:", 0

promptx2_plane BYTE "Enter the x-coordinate of the second point on the plane:", 0
prompty2_plane BYTE "Enter the y-coordinate of the second point on the plane:", 0
promptz2_plane BYTE "Enter the z-coordinate of the second point on the plane:", 0

promptx3_plane BYTE "Enter the x-coordinate of the third point on the plane:", 0
prompty3_plane BYTE "Enter the y-coordinate of the third point on the plane:", 0
promptz3_plane BYTE "Enter the z-coordinate of the third point on the plane:", 0

promptx1_line BYTE "Enter the x-coordinate of the first point on the line:", 0
prompty1_line BYTE "Enter the y-coordinate of the first point on the line:", 0
promptz1_line BYTE "Enter the z-coordinate of the first point on the line:", 0

promptx2_line BYTE "Enter the x-coordinate of the second point on the line:", 0
prompty2_line BYTE "Enter the y-coordinate of the second point on the line:", 0
promptz2_line BYTE "Enter the z-coordinate of the second point on the line:", 0

output_inputs BYTE 21 DUP (?)
output_final_result BYTE 33 DUP (?)

value BYTE 8 DUP (?)

.CODE

;Before start put the macros -  Macros go here 

;A macro for input that can be used multiple times. Outputs the prompt, puts the input into a string
;Converts the ASCII to integer, stores that integer into input_value from ax
;Converts the integer to ASCII and stores it into value which is a WORD, outputs that 
;Carriage is output next from debug.h which does a Carry Return and Line Feed.

input_macro        MACRO prompt, input_value, str

output prompt     
input str, 8
atoi str
mov input_value, ax

ENDM

;Outputs the input values for x, y, and z. Displays them in the proper format for the program.
;Used for whole numbers.

output_input_macro MACRO x_value, y_value, z_value 

mov  output_inputs, '('
itoa output_inputs + 1, x_value
mov  output_inputs + 7, ','
itoa output_inputs + 8, y_value
mov  output_inputs + 14, ','
itoa output_inputs + 15, z_value
mov  output_inputs + 21, ')' 

output carriage
output output_inputs
output carriage

ENDM

;Used to display the final result that has a decimal point format. 
;Puts the decimal point first because of the spaces that get filled in and then over written 
;in spaces that the x, y, or z values go.

output_decimal_macro MACRO x_value, y_value, z_value, decimal_point_1, decimal_point_2, decimal_point_3

mov output_final_result, '('
itoa output_final_result + 4, decimal_point_1
mov output_final_result + 7, '.'
itoa output_final_result + 1, x_value
mov output_final_result + 10, ','
itoa output_final_result + 14, decimal_point_2
mov output_final_result + 17, '.'
itoa output_final_result + 11, y_value
mov output_final_result + 20, ','
itoa output_final_result + 24, decimal_point_3
mov output_final_result + 27, '.'
itoa output_final_result + 21, z_value
mov output_final_result + 30, ')'

output carriage
output output_final_result
output carriage

ENDM

;Dot Product Macro. 

dot_product_macro MACRO a_x, a_y, a_z, b_x, b_y, b_z

;Store a_x into the ax register and then multiply that value with b_x 
;Store that value into bx
;Repeat for multiplying a_y, b_y and a_z, b_z
mov ax, a_x
imul ax, b_x
mov bx, ax

mov ax, a_y
imul ax, b_y
mov cx, ax

mov ax, a_z
imul ax, b_z

;Add all the registers values together
add ax, bx
add ax, cx

;The result is in the ax register.

ENDM

;Cross Product Macro.

cross_product_macro MACRO a_x, a_y, a_z, b_x, b_y, b_z

;First compenent of cross producted calculated and stored.
mov ax, a_y
imul ax, b_z
mov bx, a_z
imul bx, b_y
sub ax, bx
mov first_component, ax

;Second compenent of cross producted calculated and stored.
mov ax, a_z
imul ax, b_x
mov bx, a_x
imul bx, b_z
sub ax, bx
mov second_component, ax

;Third compenent of cross producted calculated and stored.
mov ax, a_x
imul ax, b_y
mov bx, a_y
imul bx, b_x
sub ax, bx
mov third_component, ax

ENDM


_start:

;Getting the inputs for Plane One
input_macro promptx1_plane, x1_plane, value
input_macro prompty1_plane, y1_plane, value
input_macro promptz1_plane, z1_plane, value

;Outputs what was inputted for Plane One
output_input_macro x1_plane, y1_plane, z1_plane

;Getting the inputs for Plane Two
input_macro promptx2_plane, x2_plane, value
input_macro prompty2_plane, y2_plane, value
input_macro promptz2_plane, z2_plane, value

;Outputs what was inputted for Plane Two
output_input_macro x2_plane, y2_plane, z2_plane

;Getting the inputs for Plane Three
input_macro promptx3_plane, x3_plane, value
input_macro prompty3_plane, y3_plane, value
input_macro promptz3_plane, z3_plane, value

;Outputs what was inputted for Plane Three
output_input_macro x3_plane, y3_plane, z3_plane

;Getting the inputs for Line One
input_macro promptx1_line, x1_line, value
input_macro prompty1_line, y1_line, value
input_macro promptz1_line, z1_line, value

;Outputs what was inputted for Line One
output_input_macro x1_line, y1_line, z1_line

;Getting the inputs for Line Two
input_macro promptx2_line, x2_line, value
input_macro prompty2_line, y2_line, value
input_macro promptz2_line, z2_line, value

;Outputs what was inputted for Line Two
output_input_macro x2_line, y2_line, z2_line

;Calculating the Normal
;Calculating PB-PA
mov ax, x2_plane
sub ax, x1_plane
mov point_subtraction_x1, ax

mov ax, y2_plane
sub ax, y1_plane
mov point_subtraction_y1, ax

mov ax, z2_plane
sub ax, z1_plane
mov point_subtraction_z1, ax

;Calculating PC-PA
mov ax, x3_plane
sub ax, x1_plane
mov point_subtraction_x2, ax

mov ax, y3_plane
sub ax, y1_plane
mov point_subtraction_y2, ax

mov ax, z3_plane
sub ax, z1_plane
mov point_subtraction_z2, ax

;Cross Product
cross_product_macro point_subtraction_x1, point_subtraction_y1, point_subtraction_z1, point_subtraction_x2, point_subtraction_y2, point_subtraction_z2

;Subtracting Points on the line from points on the plane - first set
;Storing them into dot_product_component_x1,y1,z1

mov ax, x1_plane
sub ax, x1_line
mov dot_product_component_x1, ax

mov ax, y1_plane
sub ax, y1_line
mov dot_product_component_y1, ax

mov ax, z1_plane
sub ax, z1_line
mov dot_product_component_z1, ax

;Subtracting the second set of points on the line from the first set of points on the line
;Storing them into dot_product_component_x2,y2,z2

mov ax, x2_line
sub ax, x1_line
mov dot_product_component_x2, ax

mov ax, y2_line
sub ax, y1_line
mov dot_product_component_y2, ax

mov ax, z2_line
sub ax, z1_line
mov dot_product_component_z2, ax

;Dot Product

dot_product_macro first_component, second_component, third_component, dot_product_component_x1, dot_product_component_y1, dot_product_component_z1
mov dot_product_result1, ax

;Dot Product 

dot_product_macro first_component, second_component, third_component, dot_product_component_x2, dot_product_component_y2, dot_product_component_z2
mov dot_product_result2, ax

;Calculations for Parametric Equation
mov ax, dot_product_result2
imul ax, x1_line
mov pe_x1, ax

mov ax, dot_product_result2
imul ax, y1_line
mov pe_y1, ax

mov ax, dot_product_result2
imul ax, z1_line
mov pe_z1, ax

;Calculations for Parametric Equation
mov ax, dot_product_result1
imul ax, x1_line
mov pe_x2, ax

mov ax, dot_product_result1
imul ax, y1_line
mov pe_y2, ax

mov ax, dot_product_result1
imul ax, z1_line
mov pe_z2, ax

;Calculations for Parametric Equation
mov ax, dot_product_result1
imul ax, x2_line
mov pe_x3, ax

mov ax, dot_product_result1
imul ax, y2_line
mov pe_y3, ax

mov ax, dot_product_result1
imul ax, z2_line
mov pe_z3, ax

;Calculating Final X
mov ax, pe_x1
sub ax, pe_x2
add ax, pe_x3

mov final_x, ax

;Calculating Final Y
mov ax, pe_y1
sub ax, pe_y2
add ax, pe_y3

mov final_y, ax

;Calculating Final Z
mov ax, pe_z1
sub ax, pe_z2
add ax, pe_z3

mov final_z, ax

;Final X
mov ax, 0
mov bx, 100
movsx ecx, dot_product_result2
movsx eax, final_x
cdq
imul eax, 100
idiv ecx
cwd
idiv bx
mov final_x, ax
mov final_decimal_x, dx

;Final Y
mov ax, 0
mov bx, 100
movsx ecx, dot_product_result2
movsx eax, final_y
cdq
imul eax, 100
idiv ecx
cwd
idiv bx
mov final_y, ax
mov final_decimal_y, dx

;Final Z
mov ax, 0
mov bx, 100
movsx ecx, dot_product_result2
movsx eax, final_z
cdq
imul eax, 100
idiv ecx
cwd
idiv bx
mov final_z, ax
mov final_decimal_z, dx

output_decimal_macro final_x, final_y, final_z, final_decimal_x, final_decimal_y, final_decimal_z


INVOKE ExitProcess, 0
PUBLIC _start
END
