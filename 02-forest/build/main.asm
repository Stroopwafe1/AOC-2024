section .data
	Array_OOB: db "Array index out of bounds!",0xA,0
	str0: db 83,65,70,69,10,0
	str1: db 91,73,115,83,97,102,101,93,58,32,70,97,105,108,115,32,101,113,117,97,108,32,99,104,101,99,107,10,0
	str2: db 91,73,115,83,97,102,101,93,58,32,68,101,99,114,101,97,115,105,110,103,32,119,104,101,110,32,119,101,32,119,101,114,101,32,105,110,99,114,101,97,115,105,110,103,10,0
	str3: db 91,73,115,83,97,102,101,93,58,32,73,110,99,114,101,97,115,105,110,103,32,119,104,101,110,32,119,101,32,119,101,114,101,32,100,101,99,114,101,97,115,105,110,103,10,0
	str4: db 91,73,115,83,97,102,101,93,58,32,68,101,99,114,101,97,115,105,110,103,32,115,116,101,112,32,116,111,111,32,104,105,103,104,46,32,73,115,32,0
	str5: db 91,73,115,83,97,102,101,93,58,32,73,110,99,114,101,97,115,105,110,103,32,115,116,101,112,32,116,111,111,32,104,105,103,104,46,32,73,115,32,0
	str6: db 91,73,115,83,97,102,101,93,58,32,85,110,107,110,111,119,110,32,115,97,102,101,116,121,32,99,111,100,101,32,0
	str7: db 32,0
	str8: db 78,117,109,98,101,114,32,111,102,32,114,101,112,111,114,116,115,32,115,97,102,101,32,112,49,58,32,0
	str9: db 78,117,109,98,101,114,32,111,102,32,114,101,112,111,114,116,115,32,115,97,102,101,32,112,50,58,32,0
	str10: db 67,111,117,108,100,32,110,111,116,32,111,112,101,110,32,102,105,108,101,10,0
	str11: db 67,111,117,108,100,32,110,111,116,32,114,101,97,100,32,102,114,111,109,32,102,105,108,101,10,0
	s_last_num_length db 0
section .bss
	s_buffer resb 20000
	s_numbers_in_row resq 20
	s_numbers_in_row_count resq 0

section .text
array_out_of_bounds:
	mov rdi, 2
	mov rax, 1
	mov rsi, Array_OOB
	mov rdx, 28
	syscall
	mov rdi, 1
	mov rax, 60
	syscall
global find_ui64_in_string
find_ui64_in_string:
	xor rcx, rcx
.loop:
	cmp byte [rdi+rcx], 0x30
	jl .parse_number
	cmp byte [rdi+rcx], 0x39
	jg .parse_number
	movzx rax, byte [rdi+rcx]
	push rax
	inc rcx
	jmp .loop
.parse_number:
	xor r8, r8
	xor rbx, rbx
	inc rbx
.parse_loop:
	pop rax
	sub rax, 0x30
	mul rbx
	add r8, rax
	mov rax, 10
	mul rbx
	mov rbx, rax
	loop .parse_loop
.exit:
	mov rax, r8
	ret
global print_ui64
print_ui64:
	push rbp
	mov rsi, rsp
	sub rsp, 22
	mov rax, rdi
	mov rbx, 0xA
	xor rcx, rcx
to_string_ui64:
	dec rsi
	xor rdx, rdx
	div rbx
	add rdx, 0x30 ; '0'
	mov byte [rsi], dl
	inc rcx
	test rax, rax
	jnz to_string_ui64
.write:
	inc rax
	mov rdi, 1
	mov rdx, rcx
	syscall
	add rsp, 22
	pop rbp
	ret
global print_ui64_newline
print_ui64_newline:
	push rbp
	mov rsi, rsp
	sub rsp, 22
	mov rax, rdi
	mov rbx, 0xA
	xor rcx, rcx
	dec rsi
	mov byte [rsi], bl
	inc rcx
	jmp to_string_ui64
global printString
printString:
	mov rsi, rdi
	xor rdx, rdx
.strCountLoop:
	cmp byte [rdi], 0x0
	je .strCountDone
	inc rdx
	inc rdi
	jmp .strCountLoop
.strCountDone:
	cmp rdx, 0
	je .prtDone
	mov rax, 1
	mov rdi, 1
	syscall
.prtDone:
	ret

global GetNumFromString
GetNumFromString:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 8
	mov qword [rbp-8], rdi
	sub rsp, 32
	mov rax, 0
	mov byte [rbp-12], al; VAR_DECL_ASSIGN ARRAY variable numBuffer[0]
	mov rax, 0
	mov byte [rbp-11], al; VAR_DECL_ASSIGN ARRAY variable numBuffer[1]
	mov rax, 0
	mov byte [rbp-10], al; VAR_DECL_ASSIGN ARRAY variable numBuffer[2]
	mov rax, 0
	mov byte [rbp-13], al; VAR_DECL_ASSIGN else variable numLength
	mov rax, 0
	mov byte [rbp-14], al; LOOP i
.label1:
	mov rax, 3
	cmp byte [rbp-14], al; LOOP i
	jl .inside_label1
	jmp .not_label1
.inside_label1:
	sub rsp, 8
	movzx rax, byte [rbp-14]; printExpression variable i
	mov rbx, 1
	mul rbx
	mov rbx, qword [rbp-8]
	add rax, rbx
	movzx r11, byte [rax]; printExpression ref input
	mov rax, r11
	mov byte [rbp-15], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-15]; printExpression, left identifier, rbp variable byte
	mov rbx, 48; printExpression, right char '0'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-15]; printExpression, left identifier, rbp variable byte
	mov rbx, 57; printExpression, right char '9'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovle rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and ax, bx
	test rax, rax
	jnz .if1
	jmp .else_if1
.if1:
	movzx rax, byte [rbp-13]; printExpression variable numLength
	cmp rax, 3; check bounds
	jge array_out_of_bounds
	push rax
	movzx rax, byte [rbp-15]; printExpression, left identifier, rbp variable byte
	mov rbx, 48; printExpression, right char '0'
	sub eax, ebx
	pop r11
	mov byte [rbp-12+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	movzx rax, byte [rbp-13]; printExpression, left identifier, rbp variable numLength
	mov rbx, 1; printExpression, right int
	add al, bl
	mov byte [rbp-13], al; VAR_ASSIGNMENT else variable numLength
	jmp .end_if1
.else_if1:
	movzx rax, byte [rbp-15]; printExpression, left identifier, rbp variable byte
	mov rbx, 32; printExpression, right char ' '
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-15]; printExpression, left identifier, rbp variable byte
	mov rbx, 10; printExpression, right char '\n'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	or ax, bx
	test rax, rax
	jnz .if2
	jmp .end_if2
.if2:
	jmp .not_label1
	jmp .end_if2
.end_if2:
.end_if1:
	add rsp, 8
.skip_label1:
	mov al, byte [rbp-14]; LOOP i
	inc rax
	mov byte [rbp-14], al; LOOP i
	jmp .label1
.not_label1:
	mov rax, 1
	mov byte [rbp-15], al; VAR_DECL_ASSIGN else variable multiplication
	mov rax, 0
	mov qword [rbp-23], rax; VAR_DECL_ASSIGN else variable returnVal
	mov rax, 1
	mov qword [rbp-31], rax; LOOP i
.label2:
	movzx rax, byte [rbp-13]; printExpression, left identifier, rbp variable numLength
	mov rbx, 1; printExpression, right int
	add al, bl
	cmp qword [rbp-31], rax; LOOP i
	jl .inside_label2
	jmp .not_label2
.inside_label2:
	sub rsp, 8
	movzx rax, byte [rbp-13]; printExpression, left identifier, rbp variable numLength
	mov rbx, qword [rbp-31]; printExpression, right identifier, rbp variable i
	sub rax, rbx
	mov byte [rbp-32], al; VAR_DECL_ASSIGN else variable j
	movzx rax, byte [rbp-32]; printExpression variable j
	cmp rax, 3; check bounds
	jge array_out_of_bounds
	movzx r12, byte [rbp-12+rax*1]; printExpression array numBuffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	movzx rbx, byte [rbp-15]; printExpression, right identifier, rbp variable multiplication
	pop rax; printExpression, leftPrinted, recover left
	mul qword rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-23]; printExpression, left identifier, rbp variable returnVal
	add rax, rbx
	mov qword [rbp-23], rax; VAR_ASSIGNMENT else variable returnVal
	movzx rax, byte [rbp-15]; printExpression, left identifier, rbp variable multiplication
	mov rbx, 10; printExpression, right int
	mul word bx
	mov byte [rbp-15], al; VAR_ASSIGNMENT else variable multiplication
	add rsp, 8
.skip_label2:
	mov rax, qword [rbp-31]; LOOP i
	inc rax
	mov qword [rbp-31], rax; LOOP i
	jmp .label2
.not_label2:
	movzx rax, byte [rbp-13]; printExpression variable numLength
	mov byte [s_last_num_length], al; VAR_ASSIGNMENT else variable s_last_num_length
	mov rax, qword [rbp-23]; printExpression variable returnVal
	add rsp, 32
	jmp .exit
	add rsp, 32
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

global PrintSafetyCode
PrintSafetyCode:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 8
	mov qword [rbp-8], rdi
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable code
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if3
	jmp .else_if3
.if3:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str0
	mov rdx, 5
	syscall
; =============== END FUNC CALL + STRING ===============
	jmp .end_if3
.else_if3:
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable code
	mov rbx, 1; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if4
	jmp .else_if4
.if4:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str1
	mov rdx, 28
	syscall
; =============== END FUNC CALL + STRING ===============
	jmp .end_if4
.else_if4:
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable code
	mov rbx, 2; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if5
	jmp .else_if5
.if5:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str2
	mov rdx, 45
	syscall
; =============== END FUNC CALL + STRING ===============
	jmp .end_if5
.else_if5:
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable code
	mov rbx, 3; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if6
	jmp .else_if6
.if6:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str3
	mov rdx, 45
	syscall
; =============== END FUNC CALL + STRING ===============
	jmp .end_if6
.else_if6:
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable code
	mov rbx, 1048576; printExpression, right int
	and rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1048576; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if7
	jmp .else_if7
.if7:
	sub rsp, 32
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable code
	mov rbx, 1048576; printExpression, right int
	sub rax, rbx
	mov qword [rbp-16], rax; VAR_DECL_ASSIGN else variable calc
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str4
	mov rdx, 39
	syscall
; =============== END FUNC CALL + STRING ===============
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-16]; variable calc
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
	add rsp, 32
	jmp .end_if7
.else_if7:
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable code
	mov rbx, 2097152; printExpression, right int
	and rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 2097152; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if8
	jmp .else_if8
.if8:
	sub rsp, 32
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable code
	mov rbx, 2097152; printExpression, right int
	sub rax, rbx
	mov qword [rbp-16], rax; VAR_DECL_ASSIGN else variable calc
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str5
	mov rdx, 39
	syscall
; =============== END FUNC CALL + STRING ===============
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-16]; variable calc
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
	add rsp, 32
	jmp .end_if8
.else_if8:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str6
	mov rdx, 30
	syscall
; =============== END FUNC CALL + STRING ===============
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-8]; variable code
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
.end_if8:
.end_if7:
.end_if6:
.end_if5:
.end_if4:
.end_if3:
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

global GetSafety
GetSafety:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 8
	mov byte [rbp-1], dil
	sub rsp, 48
	mov rax, 0
	cmp rax, 20; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_numbers_in_row+rax*8]; printExpression array s_numbers_in_row
	mov rax, r12
	mov qword [rbp-9], rax; VAR_DECL_ASSIGN else variable lastNum
	mov rax, 0
	mov byte [rbp-10], al; VAR_DECL_ASSIGN else variable status
	mov rax, 1
	mov qword [rbp-18], rax; VAR_DECL_ASSIGN else variable begin
	mov rax, qword [s_numbers_in_row_count]; printExpression global variable s_numbers_in_row_count
	mov qword [rbp-26], rax; VAR_DECL_ASSIGN else variable end
	movzx rax, byte [rbp-1]; printExpression, left identifier, rbp variable indexToSkip
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if9
	jmp .end_if9
.if9:
	mov rax, 1
	cmp rax, 20; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_numbers_in_row+rax*8]; printExpression array s_numbers_in_row
	mov rax, r12
	mov qword [rbp-9], rax; VAR_ASSIGNMENT else variable lastNum
	mov rax, 2
	mov qword [rbp-18], rax; VAR_ASSIGNMENT else variable begin
	jmp .end_if9
.end_if9:
	mov rax, qword [rbp-18]; printExpression variable begin
	mov qword [rbp-34], rax; LOOP i
.label3:
	mov rax, qword [rbp-26]; printExpression variable end
	cmp qword [rbp-34], rax; LOOP i
	jl .inside_label3
	jmp .not_label3
.inside_label3:
	sub rsp, 8
	mov rax, qword [rbp-34]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-1]; printExpression, right identifier, rbp variable indexToSkip
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if10
	jmp .end_if10
.if10:
	jmp .skip_label3
	jmp .end_if10
.end_if10:
	mov rax, qword [rbp-34]; printExpression variable i
	cmp rax, 20; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_numbers_in_row+rax*8]; printExpression array s_numbers_in_row
	mov rax, r12
	mov qword [rbp-42], rax; VAR_DECL_ASSIGN else variable toCheck
	mov rax, qword [rbp-42]; printExpression, left identifier, rbp variable toCheck
	mov rbx, qword [rbp-9]; printExpression, right identifier, rbp variable lastNum
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if11
	jmp .else_if11
.if11:
	mov rax, 1
	add rsp, 56
	jmp .exit
	jmp .end_if11
.else_if11:
	mov rax, qword [rbp-42]; printExpression, left identifier, rbp variable toCheck
	mov rbx, qword [rbp-9]; printExpression, right identifier, rbp variable lastNum
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovl rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if12
	jmp .else_if12
.if12:
	movzx rax, byte [rbp-10]; printExpression, left identifier, rbp variable status
	mov rbx, 1; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if13
	jmp .else_if13
.if13:
	mov rax, 2
	add rsp, 56
	jmp .exit
	jmp .end_if13
.else_if13:
	sub rsp, 8
	mov rax, 2
	mov byte [rbp-10], al; VAR_ASSIGNMENT else variable status
	mov rax, qword [rbp-9]; printExpression, left identifier, rbp variable lastNum
	mov rbx, qword [rbp-42]; printExpression, right identifier, rbp variable toCheck
	sub rax, rbx
	mov qword [rbp-50], rax; VAR_DECL_ASSIGN else variable calc
	mov rax, qword [rbp-50]; printExpression, left identifier, rbp variable calc
	mov rbx, 1; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovl rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-50]; printExpression, left identifier, rbp variable calc
	mov rbx, 3; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovg rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	or rax, rbx
	test rax, rax
	jnz .if14
	jmp .end_if14
.if14:
	mov rax, 1048576; printExpression, left int
	mov rbx, qword [rbp-50]; printExpression, right identifier, rbp variable calc
	or rax, rbx
	add rsp, 64
	jmp .exit
	jmp .end_if14
.end_if14:
	add rsp, 8
.end_if13:
	jmp .end_if12
.else_if12:
	mov rax, qword [rbp-42]; printExpression, left identifier, rbp variable toCheck
	mov rbx, qword [rbp-9]; printExpression, right identifier, rbp variable lastNum
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovg rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if15
	jmp .end_if15
.if15:
	movzx rax, byte [rbp-10]; printExpression, left identifier, rbp variable status
	mov rbx, 2; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if16
	jmp .else_if16
.if16:
	mov rax, 3
	add rsp, 56
	jmp .exit
	jmp .end_if16
.else_if16:
	sub rsp, 8
	mov rax, 1
	mov byte [rbp-10], al; VAR_ASSIGNMENT else variable status
	mov rax, qword [rbp-42]; printExpression, left identifier, rbp variable toCheck
	mov rbx, qword [rbp-9]; printExpression, right identifier, rbp variable lastNum
	sub rax, rbx
	mov qword [rbp-50], rax; VAR_DECL_ASSIGN else variable calc
	mov rax, qword [rbp-50]; printExpression, left identifier, rbp variable calc
	mov rbx, 1; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovl rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-50]; printExpression, left identifier, rbp variable calc
	mov rbx, 3; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovg rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	or rax, rbx
	test rax, rax
	jnz .if17
	jmp .end_if17
.if17:
	mov rax, 2097152; printExpression, left int
	mov rbx, qword [rbp-50]; printExpression, right identifier, rbp variable calc
	or rax, rbx
	add rsp, 64
	jmp .exit
	jmp .end_if17
.end_if17:
	add rsp, 8
.end_if16:
	jmp .end_if15
.end_if15:
.end_if12:
.end_if11:
	mov rax, qword [rbp-42]; printExpression variable toCheck
	mov qword [rbp-9], rax; VAR_ASSIGNMENT else variable lastNum
	add rsp, 8
.skip_label3:
	mov rax, qword [rbp-34]; LOOP i
	inc rax
	mov qword [rbp-34], rax; LOOP i
	jmp .label3
.not_label3:
	mov rax, 0
	add rsp, 48
	jmp .exit
	add rsp, 48
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

global Part1
Part1:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 8
	mov qword [rbp-8], rdi
	sub rsp, 24
	mov rax, 0
	mov qword [rbp-16], rax; VAR_DECL_ASSIGN else variable reportsSafe
	mov rax, 0
	mov qword [rbp-24], rax; LOOP i
.label4:
	mov rax, qword [rbp-8]; printExpression variable size
	cmp qword [rbp-24], rax; LOOP i
	jl .inside_label4
	jmp .not_label4
.inside_label4:
	sub rsp, 8
	mov rax, qword [rbp-24]; printExpression variable i
	cmp rax, 20000; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-25], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable byte
	mov rbx, 48; printExpression, right char '0'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable byte
	mov rbx, 57; printExpression, right char '9'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovle rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and ax, bx
	test rax, rax
	jnz .if18
	jmp .else_if18
.if18:
	sub rsp, 40
	lea rax, [s_buffer]; printExpression variable s_buffer
	push rax; printExpression, leftPrinted, save left
	mov rbx, qword [rbp-24]; printExpression, right identifier, rbp variable i
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov qword [rbp-33], rax; VAR_DECL_ASSIGN else variable c
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-33]; printExpression variable c
	mov rdi, rax
	call GetNumFromString
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov qword [rbp-41], rax; VAR_DECL_ASSIGN else variable num
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-41]; variable num
	call print_ui64
; =============== END FUNC CALL + VARIABLE ===============
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str7
	mov rdx, 1
	syscall
; =============== END FUNC CALL + STRING ===============
	movzx rax, byte [s_last_num_length]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	sub ax, bx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp variable i
	add rax, rbx
	mov qword [rbp-24], rax; VAR_ASSIGNMENT else variable i
	mov rax, qword [s_numbers_in_row_count]; printExpression global variable s_numbers_in_row_count
	cmp rax, 20; check bounds
	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-41]; printExpression variable num
	pop r11
	mov qword [s_numbers_in_row+r11*8], rax; VAR_ASSIGNMENT ARRAY s_numbers_in_row
	mov rax, qword [s_numbers_in_row_count]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [s_numbers_in_row_count], rax; VAR_ASSIGNMENT else variable s_numbers_in_row_count
	add rsp, 40
	jmp .end_if18
.else_if18:
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable byte
	mov rbx, 10; printExpression, right char '\n'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if19
	jmp .end_if19
.if19:
	sub rsp, 8
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, -1
	mov rdi, rax
	call GetSafety
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov qword [rbp-33], rax; VAR_DECL_ASSIGN else variable safety
	mov rax, qword [rbp-33]; printExpression variable safety
	mov rdi, rax
	call PrintSafetyCode
	mov rax, qword [rbp-33]; printExpression, left identifier, rbp variable safety
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if20
	jmp .end_if20
.if20:
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable reportsSafe
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-16], rax; VAR_ASSIGNMENT else variable reportsSafe
	jmp .end_if20
.end_if20:
	mov rax, 0
	mov qword [s_numbers_in_row_count], rax; VAR_ASSIGNMENT else variable s_numbers_in_row_count
	add rsp, 8
	jmp .end_if19
.end_if19:
.end_if18:
	add rsp, 8
.skip_label4:
	mov rax, qword [rbp-24]; LOOP i
	inc rax
	mov qword [rbp-24], rax; LOOP i
	jmp .label4
.not_label4:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str8
	mov rdx, 27
	syscall
; =============== END FUNC CALL + STRING ===============
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-16]; variable reportsSafe
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
	add rsp, 24
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

global BruteforcePart2
BruteforcePart2:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 0
	sub rsp, 16
	mov rax, 0
	mov qword [rbp-8], rax; LOOP i
.label5:
	mov rax, qword [s_numbers_in_row_count]; printExpression global variable s_numbers_in_row_count
	cmp qword [rbp-8], rax; LOOP i
	jl .inside_label5
	jmp .not_label5
.inside_label5:
	sub rsp, 8
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-8]; printExpression variable i
	mov rdi, rax
	call GetSafety
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov qword [rbp-16], rax; VAR_DECL_ASSIGN else variable safety
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable safety
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if21
	jmp .end_if21
.if21:
	mov rax, 1
	add rsp, 24
	jmp .exit
	jmp .end_if21
.end_if21:
	add rsp, 8
.skip_label5:
	mov rax, qword [rbp-8]; LOOP i
	inc rax
	mov qword [rbp-8], rax; LOOP i
	jmp .label5
.not_label5:
	mov rax, 0
	add rsp, 16
	jmp .exit
	add rsp, 16
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

global Part2
Part2:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 8
	mov qword [rbp-8], rdi
	sub rsp, 24
	mov rax, 0
	mov qword [rbp-16], rax; VAR_DECL_ASSIGN else variable reportsSafe
	mov rax, 0
	mov qword [rbp-24], rax; LOOP i
.label6:
	mov rax, qword [rbp-8]; printExpression variable size
	cmp qword [rbp-24], rax; LOOP i
	jl .inside_label6
	jmp .not_label6
.inside_label6:
	sub rsp, 8
	mov rax, qword [rbp-24]; printExpression variable i
	cmp rax, 20000; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-25], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable byte
	mov rbx, 48; printExpression, right char '0'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable byte
	mov rbx, 57; printExpression, right char '9'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovle rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and ax, bx
	test rax, rax
	jnz .if22
	jmp .else_if22
.if22:
	sub rsp, 40
	lea rax, [s_buffer]; printExpression variable s_buffer
	push rax; printExpression, leftPrinted, save left
	mov rbx, qword [rbp-24]; printExpression, right identifier, rbp variable i
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov qword [rbp-33], rax; VAR_DECL_ASSIGN else variable c
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-33]; printExpression variable c
	mov rdi, rax
	call GetNumFromString
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov qword [rbp-41], rax; VAR_DECL_ASSIGN else variable num
	movzx rax, byte [s_last_num_length]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	sub ax, bx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp variable i
	add rax, rbx
	mov qword [rbp-24], rax; VAR_ASSIGNMENT else variable i
	mov rax, qword [s_numbers_in_row_count]; printExpression global variable s_numbers_in_row_count
	cmp rax, 20; check bounds
	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-41]; printExpression variable num
	pop r11
	mov qword [s_numbers_in_row+r11*8], rax; VAR_ASSIGNMENT ARRAY s_numbers_in_row
	mov rax, qword [s_numbers_in_row_count]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [s_numbers_in_row_count], rax; VAR_ASSIGNMENT else variable s_numbers_in_row_count
	add rsp, 40
	jmp .end_if22
.else_if22:
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable byte
	mov rbx, 10; printExpression, right char '\n'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if23
	jmp .end_if23
.if23:
	sub rsp, 8
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, -1
	mov rdi, rax
	call GetSafety
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov qword [rbp-33], rax; VAR_DECL_ASSIGN else variable safety
	mov rax, qword [rbp-33]; printExpression, left identifier, rbp variable safety
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if24
	jmp .else_if24
.if24:
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable reportsSafe
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-16], rax; VAR_ASSIGNMENT else variable reportsSafe
	jmp .end_if24
.else_if24:
	sub rsp, 8
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	call BruteforcePart2
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov byte [rbp-34], al; VAR_DECL_ASSIGN else variable safe
	movzx rax, byte [rbp-34]; printExpression variable safe
	test rax, rax
	jnz .if25
	jmp .end_if25
.if25:
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable reportsSafe
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-16], rax; VAR_ASSIGNMENT else variable reportsSafe
	jmp .end_if25
.end_if25:
	add rsp, 8
.end_if24:
	mov rax, 0
	mov qword [s_numbers_in_row_count], rax; VAR_ASSIGNMENT else variable s_numbers_in_row_count
	add rsp, 8
	jmp .end_if23
.end_if23:
.end_if22:
	add rsp, 8
.skip_label6:
	mov rax, qword [rbp-24]; LOOP i
	inc rax
	mov qword [rbp-24], rax; LOOP i
	jmp .label6
.not_label6:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str9
	mov rdx, 27
	syscall
; =============== END FUNC CALL + STRING ===============
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-16]; variable reportsSafe
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
	add rsp, 24
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============
	global _start

_start:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 16
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, 1
	cmp rax, qword [rbp+16]; check bounds
	jge array_out_of_bounds
	mov r12, qword [rbp+16+rax*8]; printExpression array argv
	mov rax, r12
	mov rdi, rax
	mov rax, 0
	mov rsi, rax
	mov rax, 0
	mov rdx, rax
	mov rax, 2
	syscall
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov dword [rbp-4], eax; VAR_DECL_ASSIGN else variable fd
	mov eax, dword [rbp-4]; printExpression, left identifier, rbp variable fd
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp eax, ebx
	cmovl rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if26
	jmp .end_if26
.if26:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str10
	mov rdx, 20
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, -1
	add rsp, 16
	jmp .exit
	jmp .end_if26
.end_if26:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov eax, dword [rbp-4]; printExpression variable fd
	mov rdi, rax
	lea rax, [s_buffer]; printExpression variable s_buffer
	mov rsi, rax
	mov rax, 20000
	mov rdx, rax
	mov rax, 0
	syscall
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov qword [rbp-12], rax; VAR_DECL_ASSIGN else variable size
	mov rax, qword [rbp-12]; printExpression, left identifier, rbp variable size
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if27
	jmp .end_if27
.if27:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str11
	mov rdx, 25
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, -1
	add rsp, 16
	jmp .exit
	jmp .end_if27
.end_if27:
	mov rax, qword [rbp-12]; printExpression variable size
	mov rdi, rax
	call Part1
	mov rax, qword [rbp-12]; printExpression variable size
	mov rdi, rax
	call Part2
	mov rax, 0
	mov rdi, rax
	add rsp, 16
.exit:
	mov rax, 60
	syscall
