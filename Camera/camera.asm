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

;Used for Cross Product & u numerators
first_component WORD ?
second_component WORD ?
third_component WORD ?

;Coordinates for Camera Eyepoint
x_eye WORD ?
y_eye WORD ?
z_eye WORD ?

;Coordinates for Camera Look at Point
x_point WORD ?
y_point WORD ?
z_point WORD ?

;Coordinates for Camera Direction
x_direction WORD ?
y_direction WORD ?
z_direction WORD ?

;Variables used in calculating n
nx WORD ?
ny WORD ?
nz WORD ?
n_denom WORD ?
dot_product_result_n WORD ?

;Variables used in calculating v
first_v_x WORD ?
first_v_y WORD ?
first_v_z WORD ?
second_v_x WORD ?
second_v_y WORD ?
second_v_z WORD ?
final_v_x WORD ?
final_v_y WORD ?
final_v_z WORD ?
v_denom WORD ?
dot_product_result_v WORD ?
dot_product_result_nv WORD ?

;Variables used in calculating u
u_denom WORD ?
dot_product_result_u WORD ?

;Words Before Bytes

;Prompts for Camera Eyepoint
prompt_x_eye BYTE "Enter the x-coordinate of the camera eyepoint:", 0
prompt_y_eye BYTE "Enter the y-coordinate of the camera eyepoint:", 0
prompt_z_eye BYTE "Enter the z-coordinate of the camera eyepoint:", 0

;Prompts for Camera Look at Point
prompt_x_point BYTE "Enter the x-coordinate of the camera look at point:", 0
prompt_y_point BYTE "Enter the y-coordinate of the camera look at point:", 0
prompt_z_point BYTE "Enter the z-coordinate of the camera look at point:", 0

;Prompts for Camera Direction
prompt_x_direction BYTE "Enter the x-coordinate of the camera up direction:",0
prompt_y_direction BYTE "Enter the y-coordinate of the camera up direction:",0
prompt_z_direction BYTE "Enter the z-coordinate of the camera up direction:",0

;Variables for Output
n BYTE "n:", 0
v BYTE "v:", 0
u BYTE "u:", 0

;Output the Inputs
output_inputs BYTE 21 DUP (?)

;Output final Result
output_final_result BYTE 50 DUP (?)

;Output for testing
output_test BYTE 21 DUP (?)

;Value
value BYTE 8 DUP (?)

.CODE
;Macros go here - before .start 

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

final_output_macro MACRO denom, x_numerator, y_numerator, z_numerator

;Might have to change to first line as +5 - check recording

itoa output_final_result + 5, denom
mov output_final_result, '('
itoa output_final_result + 1, x_numerator
mov output_final_result + 7, '/'
itoa output_final_result + 15, denom
itoa output_final_result + 11, y_numerator
mov output_final_result + 11, ','
mov output_final_result + 17, '/'
itoa output_final_result + 25, denom
itoa output_final_result + 21, z_numerator
mov output_final_result + 21, ','
mov output_final_result + 27, '/'
mov output_final_result + 31, ')'

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

;Getting inputs for Camera eyepoint
input_macro prompt_x_eye, x_eye, value
input_macro prompt_y_eye, y_eye, value
input_macro prompt_z_eye, z_eye, value

;Outputs Inputs for Camera Eyepoints
output_input_macro x_eye, y_eye, z_eye

;Getting input for Camera Look at Point
input_macro prompt_x_point, x_point, value
input_macro prompt_y_point, y_point, value
input_macro prompt_z_point, z_point, value

;Outputs Inputs for Camera Look at Points
output_input_macro x_point, y_point, z_point

;Getting inputs for Camera Direction
input_macro prompt_x_direction, x_direction, value
input_macro prompt_y_direction, y_direction, value
input_macro prompt_z_direction, z_direction, value

;Outputs Inputs for Camera Direction
output_input_macro x_direction, y_direction, z_direction

;Calculating n
;Calculating Eye point-At point
mov ax, x_eye
sub ax, x_point
mov nx, ax

mov ax, y_eye
sub ax, y_point
mov ny, ax

mov ax, z_eye
sub ax, z_point
mov nz, ax

;n = nx, ny, nz

;Dot Product of n*n to get length
;sqrt of length to get denominator
dot_product_macro nx, ny, nz, nx, ny, nz
mov dot_product_result_n, ax

sqrt dot_product_result_n
;result in ax
mov n_denom, ax

;CALCULATING N END

;Calculating v
;v = -(v_up.n)*n + (n.n)v_up
;This needs to be negative
;Calculating -(v_up.n) * n
dot_product_macro nx, ny, nz, x_direction, y_direction, z_direction

;Negate dot_product_macro ax result
neg ax

;This mov needed?
mov dot_product_result_nv, ax

;Calculating first half of equation for x, y, z
mov ax, dot_product_result_nv
imul ax, nx
mov first_v_x, ax

mov ax, dot_product_result_nv
imul ax, ny
mov first_v_y, ax

mov ax, dot_product_result_nv
imul ax, nz
mov first_v_z, ax

;Calculating (n.n)v_up
;n.n already computer - stored in n_denom
;Calculating second half of equation for x, y, z
mov ax, dot_product_result_n
imul ax, x_direction
mov second_v_x, ax

mov ax, dot_product_result_n
imul ax, y_direction
mov second_v_y, ax

mov ax, dot_product_result_n
imul ax, z_direction
mov second_v_z, ax

;Calculating final x, y, z for v
;Numerators
mov ax, first_v_x
mov bx, second_v_x
add ax, bx
mov final_v_x, ax

mov ax, first_v_y
mov bx, second_v_y
add ax, bx
mov final_v_y, ax

mov ax, first_v_z
mov bx, second_v_z
add ax, bx
mov final_v_z, ax
;Calculating v denominator
;sqrt(v.v)
dot_product_macro final_v_x, final_v_y, final_v_z, final_v_x, final_v_y, final_v_z
mov dot_product_result_v, ax
sqrt dot_product_result_v
mov v_denom, ax

;Calculating V END

;Calculating u
;Cross-Product v cross n - must be done this way for right hand coordinate
;If u is incorrect check if orthgonal n*u=0 

cross_product_macro final_v_x, final_v_y, final_v_z, nx, ny, nz
;Each part stored in first, second, and third components 
;These are the Numerators

;Calculating u denom
;sqrt(u.u) Must be less than 32,767 to not have overflow
dot_product_macro first_component, second_component, third_component, first_component, second_component, third_component
mov dot_product_result_u, ax
sqrt dot_product_result_u
mov u_denom, ax

;CALCULATING U END

;Output u:
output u
final_output_macro u_denom, first_component, second_component, third_component

;Output v:
output v
final_output_macro v_denom, final_v_x, final_v_y, final_v_z

;Output n:
output n
final_output_macro n_denom, nx, ny, nz

INVOKE ExitProcess, 0
PUBLIC _start
END