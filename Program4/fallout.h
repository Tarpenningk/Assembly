.NOLIST
.386

EXTRN fallouthacking_proc : Near32

fallouthacking MACRO array_name, length_of_element, num_of_elements, index, num_of_matches, xtra
	IFB <array_name>
		.ERR <missing "array_name" operand in fallouthack>
	ELSEIFB <length_of_element>
		.ERR <missing "length_of_element" operand in fallouthack>
	ELSEIFB <num_of_elements>
		.ERR <missing "num_of_elements" operand in fallouthack>
	ELSEIFB <index>
		.ERR <missing "index" operand in fallouthack>
	ELSEIFB <num_of_matches>
		.ERR <missing "num_of_matches" operand in fallouthack>
	ELSEIFNB <xtra>
		.ERR <extra operand(s) in fallouthack>
	ELSE
	push ebx
	lea ebx, array_name
	push ebx
		push length_of_element
		push num_of_elements
		push index
		push num_of_matches
		call fallouthacking_proc
    pop ebx
    ENDIF
	ENDM
.NOLISTMACRO
.LIST