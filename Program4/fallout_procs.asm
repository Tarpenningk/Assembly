.386
.MODEL FLAT
;Includes
INCLUDE str_utils.h
;Links everything up
PUBLIC fallouthacking_proc

;Macros

swapIt MACRO first_string, second_string
push first_string
push second_string
;Line: 
call swap_proc
ENDM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getAddressOfArray MACRO offset, length, index
push offset
push length
push index
;Line:
call getThoseAddresses
ENDM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
numberOfMatches MACRO first_string, second_string
push first_string
push second_string
;Line:
call characterMatching
ENDM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.CODE

;EQUs 
address_of_all_passwords EQU [ebp + 16]
num_characters_in_passwordof_password EQU [ebp + 14]
number_of_passwords EQU [ebp + 12]
index_check EQU [ebp + 10]
number_of_matches_needed EQU [ebp + 8]
current_string_address EQU [ebp - 4]
compare_string_address EQU [ebp - 8] 
final_string_address EQU [ebp - 12] 

fallouthacking_proc PROC NEAR32
push   ebp               
mov    ebp, esp    
sub    esp, 12
push   edi              
push   esi
push   ecx
push   edx
pushf
getAddressOfArray address_of_all_passwords, WORD PTR num_characters_in_passwordof_password, WORD PTR index_check
mov compare_string_address, eax
getAddressOfArray address_of_all_passwords, WORD PTR num_characters_in_passwordof_password, WORD PTR number_of_passwords
mov final_string_address, eax
mov ecx, compare_string_address
mov edx, ecx
mov eax, final_string_address
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
whileNeedingToSwap:
cmp edx, eax
je doneSwapping
add dx, WORD PTR num_characters_in_passwordof_password
swapIt edx, ecx
add cx, WORD PTR num_characters_in_passwordof_password
jmp whileNeedingToSwap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
doneSwapping:
mov ecx, 0
mov edx, 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
whileGoingThroughStrings:
cmp dx, number_of_passwords
je endWhileGoingThroughStrings
getAddressOfArray address_of_all_passwords, WORD PTR num_characters_in_passwordof_password, dx
mov current_string_address, eax
numberOfMatches current_string_address, final_string_address
cmp ax, number_of_matches_needed
jne matchNotFound
inc cx
getAddressOfArray address_of_all_passwords, WORD PTR num_characters_in_passwordof_password, cx
mov compare_string_address, eax
swapIt current_string_address, compare_string_address
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
matchNotFound:
inc dx
jmp whileGoingThroughStrings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;      
endWhileGoingThroughStrings:
mov eax, ecx
popf       
pop    edx
pop    ecx           
pop    esi
pop    edi
mov    esp, ebp
pop    ebp
ret    12               
fallouthacking_proc     ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
test_string_1  EQU [ebp + 12]
test_string_2  EQU [ebp + 8]
characterMatching 	PROC NEAR32
push   ebp                
mov    ebp, esp           
push   edi              
push   esi
push   ebx
push   ecx
pushf
mov    esi, test_string_1
mov    edi, test_string_2
cld
push test_string_1
call strlen_proc
mov cx, ax
mov ax, 0
checkForMatchingCharacters:
repne cmpsb
jnz matchNotFound
inc ax
matchNotFound:
cmp cx, 0
jne checkForMatchingCharacters
popf              
pop    ecx
pop    ebx     
pop    esi
pop    edi
mov    esp, ebp
pop    ebp
ret    8
characterMatching     ENDP
address_of_all_passwords     EQU [ebp + 12]
;AKA length of string
num_characters_in_password     EQU [ebp + 10]
index_      EQU [ebp + 8]
getThoseAddresses     PROC NEAR32
push   ebp                
mov    ebp, esp           
push   ebx
push   edx ; used in mul
pushf
mov eax, 0
mov ebx, 0
mov ax, index_
mov bx, num_characters_in_password
sub ax, 1
mul bx
add eax, address_of_all_passwords
popf       
pop    edx            
pop    ebx
mov    esp, ebp
pop    ebp
ret    8               
getThoseAddresses     ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
swap_proc      PROC    NEAR32
first_string        EQU [ebp + 12]
second_string        EQU [ebp + 8]
begin:
push	ebp
mov	ebp, esp                    
push    eax		
push    ecx
push    esi
push    edi
pushf	             
push first_string
call strlen_proc
inc  ax
mov  ecx, 0
mov  cx, ax
mov esi, first_string
mov edi, second_string
swapThem:
lodsb
sub     esi, 1
xchg    esi, edi
movsb
xchg    esi, edi
sub     edi, 1
stosb
loop swapThem

;can't do end
end_:
;Exit code Time
popf	                 
	pop edi
	pop esi
	pop ecx
	pop eax
	mov esp, ebp	
pop	ebp

ret	8		
swap_proc    ENDP
END