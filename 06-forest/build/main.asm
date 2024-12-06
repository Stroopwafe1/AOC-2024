section .data
	Array_OOB: db "Array index out of bounds!",0xA,0
	str0: db 80,108,97,121,101,114,32,101,115,99,97,112,101,100,32,120,10,0
	str1: db 80,108,97,121,101,114,32,101,115,99,97,112,101,100,32,121,10,0
	str2: db 84,117,114,110,101,100,32,97,116,32,0
	str3: db 44,32,0
	str4: db 80,97,114,116,32,49,58,32,0
	str5: db 80,97,114,116,32,50,58,32,0
	str6: db 67,111,117,108,100,32,110,111,116,32,111,112,101,110,32,102,105,108,101,0
	str7: db 67,111,117,108,100,32,110,111,116,32,114,101,97,100,32,102,114,111,109,32,102,105,108,101,0
	s_height dq 0
	s_pos_count dq 0
	s_start_x dq 0
	s_start_y dq 0
	s_visited_count dq 0
	s_width dq 0
section .bss
	s_buffer resb 20000
	s_visited_x resq 10000
	s_visited_y resq 10000
	s_xs resq 2000
	s_ys resq 2000

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

global Setup
Setup:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 8
	mov qword [rbp-8], rdi
	sub rsp, 24
	mov rax, 0
	mov qword [rbp-16], rax; VAR_DECL_ASSIGN else variable y
	mov rax, 0
	mov qword [rbp-24], rax; LOOP i
.label1:
	mov rax, qword [rbp-8]; printExpression variable size
	cmp qword [rbp-24], rax; LOOP i
	jl .inside_label1
	jmp .not_label1
.inside_label1:
	sub rsp, 8
	mov rax, qword [rbp-24]; printExpression variable i
	cmp rax, 20000; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-25], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable byte
	mov rbx, 10; printExpression, right char '\n'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if1
	jmp .else_if1
.if1:
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable y
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-16], rax; VAR_ASSIGNMENT else variable y
	mov rax, qword [s_height]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [s_height], rax; VAR_ASSIGNMENT else variable s_height
	mov rax, qword [s_width]; printExpression, left identifier, not rbp
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if2
	jmp .end_if2
.if2:
	mov rax, qword [rbp-24]; printExpression variable i
	mov qword [s_width], rax; VAR_ASSIGNMENT else variable s_width
	jmp .end_if2
.end_if2:
	jmp .end_if1
.else_if1:
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable byte
	mov rbx, 35; printExpression, right char '#'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if3
	jmp .else_if3
.if3:
	mov rax, qword [s_pos_count]; printExpression global variable s_pos_count
	cmp rax, 2000; check bounds
	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-16]; printExpression variable y
	pop r11
	mov qword [s_ys+r11*8], rax; VAR_ASSIGNMENT ARRAY s_ys
	mov rax, qword [s_width]; printExpression, left identifier, not rbp
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if4
	jmp .else_if4
.if4:
	mov rax, qword [s_pos_count]; printExpression global variable s_pos_count
	cmp rax, 2000; check bounds
	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-24]; printExpression variable i
	pop r11
	mov qword [s_xs+r11*8], rax; VAR_ASSIGNMENT ARRAY s_xs
	jmp .end_if4
.else_if4:
	mov rax, qword [s_pos_count]; printExpression global variable s_pos_count
	cmp rax, 2000; check bounds
	jge array_out_of_bounds
	push rax
	mov rax, qword [s_width]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp variable i
	cqo
	xor rdx, rdx; Clearing rdx for division
	idiv rax, rbx
	mov rax, rdx
	pop r11
	mov qword [s_xs+r11*8], rax; VAR_ASSIGNMENT ARRAY s_xs
.end_if4:
	mov rax, qword [s_pos_count]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [s_pos_count], rax; VAR_ASSIGNMENT else variable s_pos_count
	jmp .end_if3
.else_if3:
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable byte
	mov rbx, 94; printExpression, right char '^'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if5
	jmp .end_if5
.if5:
	mov rax, qword [s_width]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp variable i
	cqo
	xor rdx, rdx; Clearing rdx for division
	idiv rax, rbx
	mov rax, rdx
	mov qword [s_start_x], rax; VAR_ASSIGNMENT else variable s_start_x
	mov rax, qword [rbp-16]; printExpression variable y
	mov qword [s_start_y], rax; VAR_ASSIGNMENT else variable s_start_y
	jmp .end_if5
.end_if5:
.end_if3:
.end_if1:
	add rsp, 8
.skip_label1:
	mov rax, qword [rbp-24]; LOOP i
	inc rax
	mov qword [rbp-24], rax; LOOP i
	jmp .label1
.not_label1:
	add rsp, 24
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
	sub rsp, 0
	sub rsp, 32
	mov rax, qword [s_start_x]; printExpression global variable s_start_x
	mov qword [rbp-8], rax; VAR_DECL_ASSIGN else variable x
	mov rax, qword [s_start_y]; printExpression global variable s_start_y
	mov qword [rbp-16], rax; VAR_DECL_ASSIGN else variable y
	mov rax, 0
	mov byte [rbp-17], al; VAR_DECL_ASSIGN else variable x_dir
	mov rax, -1
	mov byte [rbp-18], al; VAR_DECL_ASSIGN else variable y_dir
	mov rax, 0
	mov qword [rbp-26], rax; VAR_DECL_ASSIGN else variable sum
	mov rax, qword [s_visited_count]; printExpression global variable s_visited_count
	cmp rax, 10000; check bounds
	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-8]; printExpression variable x
	pop r11
	mov qword [s_visited_x+r11*8], rax; VAR_ASSIGNMENT ARRAY s_visited_x
	mov rax, qword [s_visited_count]; printExpression global variable s_visited_count
	cmp rax, 10000; check bounds
	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-16]; printExpression variable y
	pop r11
	mov qword [s_visited_y+r11*8], rax; VAR_ASSIGNMENT ARRAY s_visited_y
	mov rax, qword [s_visited_count]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [s_visited_count], rax; VAR_ASSIGNMENT else variable s_visited_count
.label2:
	sub rsp, 32
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable x
	movsx rbx, byte [rbp-17]; printExpression, right identifier, rbp variable x_dir
	add rax, rbx
	mov qword [rbp-34], rax; VAR_DECL_ASSIGN else variable x_next
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable y
	movsx rbx, byte [rbp-18]; printExpression, right identifier, rbp variable y_dir
	add rax, rbx
	mov qword [rbp-42], rax; VAR_DECL_ASSIGN else variable y_next
	mov rax, 0
	mov byte [rbp-43], al; VAR_DECL_ASSIGN else variable turned
	mov rax, qword [rbp-34]; printExpression, left identifier, rbp variable x_next
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovl rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-34]; printExpression, left identifier, rbp variable x_next
	mov rbx, qword [s_width]; printExpression, right identifier, not rbp
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	or rax, rbx
	test rax, rax
	jnz .if6
	jmp .else_if6
.if6:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str0
	mov rdx, 17
	syscall
; =============== END FUNC CALL + STRING ===============
	jmp .not_label2
	jmp .end_if6
.else_if6:
	mov rax, qword [rbp-42]; printExpression, left identifier, rbp variable y_next
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovl rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-42]; printExpression, left identifier, rbp variable y_next
	mov rbx, qword [s_height]; printExpression, right identifier, not rbp
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	or rax, rbx
	test rax, rax
	jnz .if7
	jmp .end_if7
.if7:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str1
	mov rdx, 17
	syscall
; =============== END FUNC CALL + STRING ===============
	jmp .not_label2
	jmp .end_if7
.end_if7:
.end_if6:
	mov rax, 0
	mov qword [rbp-51], rax; LOOP i
.label3:
	mov rax, qword [s_pos_count]; printExpression global variable s_pos_count
	cmp qword [rbp-51], rax; LOOP i
	jl .inside_label3
	jmp .not_label3
.inside_label3:
	sub rsp, 16
	mov rax, qword [rbp-51]; printExpression variable i
	cmp rax, 2000; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_xs+rax*8]; printExpression array s_xs
	mov rax, r12
	mov qword [rbp-59], rax; VAR_DECL_ASSIGN else variable x_check
	mov rax, qword [rbp-51]; printExpression variable i
	cmp rax, 2000; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_ys+rax*8]; printExpression array s_ys
	mov rax, r12
	mov qword [rbp-67], rax; VAR_DECL_ASSIGN else variable y_check
	mov rax, qword [rbp-59]; printExpression, left identifier, rbp variable x_check
	mov rbx, qword [rbp-34]; printExpression, right identifier, rbp variable x_next
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-67]; printExpression, left identifier, rbp variable y_check
	mov rbx, qword [rbp-42]; printExpression, right identifier, rbp variable y_next
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and rax, rbx
	test rax, rax
	jnz .if8
	jmp .end_if8
.if8:
	movsx rax, byte [rbp-18]; printExpression, left identifier, rbp variable y_dir
	mov rbx, -1; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if9
	jmp .else_if9
.if9:
	mov rax, 0
	mov byte [rbp-18], al; VAR_ASSIGNMENT else variable y_dir
	mov rax, 1
	mov byte [rbp-17], al; VAR_ASSIGNMENT else variable x_dir
	jmp .end_if9
.else_if9:
	movsx rax, byte [rbp-17]; printExpression, left identifier, rbp variable x_dir
	mov rbx, 1; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if10
	jmp .else_if10
.if10:
	mov rax, 0
	mov byte [rbp-17], al; VAR_ASSIGNMENT else variable x_dir
	mov rax, 1
	mov byte [rbp-18], al; VAR_ASSIGNMENT else variable y_dir
	jmp .end_if10
.else_if10:
	movsx rax, byte [rbp-18]; printExpression, left identifier, rbp variable y_dir
	mov rbx, 1; printExpression, right int
	test rax, rax
	jnz .if11
	jmp .else_if11
.if11:
	mov rax, 0
	mov byte [rbp-18], al; VAR_ASSIGNMENT else variable y_dir
	mov rax, -1
	mov byte [rbp-17], al; VAR_ASSIGNMENT else variable x_dir
	jmp .end_if11
.else_if11:
	mov rax, 0
	mov byte [rbp-17], al; VAR_ASSIGNMENT else variable x_dir
	mov rax, -1
	mov byte [rbp-18], al; VAR_ASSIGNMENT else variable y_dir
.end_if11:
.end_if10:
.end_if9:
	mov rax, 1
	mov byte [rbp-43], al; VAR_ASSIGNMENT else variable turned
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str2
	mov rdx, 10
	syscall
; =============== END FUNC CALL + STRING ===============
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-59]; variable x_check
	call print_ui64
; =============== END FUNC CALL + VARIABLE ===============
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str3
	mov rdx, 2
	syscall
; =============== END FUNC CALL + STRING ===============
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-67]; variable y_check
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
	jmp .not_label3
	jmp .end_if8
.end_if8:
	add rsp, 16
.skip_label3:
	mov rax, qword [rbp-51]; LOOP i
	inc rax
	mov qword [rbp-51], rax; LOOP i
	jmp .label3
.not_label3:
	movzx rax, byte [rbp-43]; printExpression variable turned
	test rax, rax
	jnz .if12
	jmp .end_if12
.if12:
	jmp .skip_label2
	jmp .end_if12
.end_if12:
	mov rax, qword [rbp-34]; printExpression variable x_next
	mov qword [rbp-8], rax; VAR_ASSIGNMENT else variable x
	mov rax, qword [rbp-42]; printExpression variable y_next
	mov qword [rbp-16], rax; VAR_ASSIGNMENT else variable y
	mov rax, qword [rbp-26]; printExpression, left identifier, rbp variable sum
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-26], rax; VAR_ASSIGNMENT else variable sum
	mov rax, 0
	mov byte [rbp-52], al; VAR_DECL_ASSIGN else variable alreadyAdded
	mov rax, 0
	mov qword [rbp-60], rax; LOOP i
.label4:
	mov rax, qword [s_visited_count]; printExpression global variable s_visited_count
	cmp qword [rbp-60], rax; LOOP i
	jl .inside_label4
	jmp .not_label4
.inside_label4:
	sub rsp, 16
	mov rax, qword [rbp-60]; printExpression variable i
	cmp rax, 10000; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_visited_x+rax*8]; printExpression array s_visited_x
	mov rax, r12
	mov qword [rbp-68], rax; VAR_DECL_ASSIGN else variable x_check
	mov rax, qword [rbp-60]; printExpression variable i
	cmp rax, 10000; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_visited_y+rax*8]; printExpression array s_visited_y
	mov rax, r12
	mov qword [rbp-76], rax; VAR_DECL_ASSIGN else variable y_check
	mov rax, qword [rbp-68]; printExpression, left identifier, rbp variable x_check
	mov rbx, qword [rbp-8]; printExpression, right identifier, rbp variable x
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-76]; printExpression, left identifier, rbp variable y_check
	mov rbx, qword [rbp-16]; printExpression, right identifier, rbp variable y
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and rax, rbx
	test rax, rax
	jnz .if13
	jmp .end_if13
.if13:
	mov rax, 1
	mov byte [rbp-52], al; VAR_ASSIGNMENT else variable alreadyAdded
	jmp .not_label4
	jmp .end_if13
.end_if13:
	add rsp, 16
.skip_label4:
	mov rax, qword [rbp-60]; LOOP i
	inc rax
	mov qword [rbp-60], rax; LOOP i
	jmp .label4
.not_label4:
	movzx rax, byte [rbp-52]; printExpression !alreadyAdded
	xor rax, 1
	test rax, rax
	jnz .if14
	jmp .end_if14
.if14:
	mov rax, qword [s_visited_count]; printExpression global variable s_visited_count
	cmp rax, 10000; check bounds
	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-8]; printExpression variable x
	pop r11
	mov qword [s_visited_x+r11*8], rax; VAR_ASSIGNMENT ARRAY s_visited_x
	mov rax, qword [s_visited_count]; printExpression global variable s_visited_count
	cmp rax, 10000; check bounds
	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-16]; printExpression variable y
	pop r11
	mov qword [s_visited_y+r11*8], rax; VAR_ASSIGNMENT ARRAY s_visited_y
	mov rax, qword [s_visited_count]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [s_visited_count], rax; VAR_ASSIGNMENT else variable s_visited_count
	jmp .end_if14
.end_if14:
	add rsp, 32
.skip_label2:
	jmp .label2
.not_label2:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str4
	mov rdx, 8
	syscall
; =============== END FUNC CALL + STRING ===============
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [s_visited_count]; variable s_visited_count
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-26]; variable sum
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
	add rsp, 32
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
	sub rsp, 0
	sub rsp, 32
	mov rax, 0
	mov qword [rbp-8], rax; VAR_DECL_ASSIGN else variable sum
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str5
	mov rdx, 8
	syscall
; =============== END FUNC CALL + STRING ===============
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-8]; variable sum
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
	add rsp, 32
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
	mov qword [rbp-8], rax; VAR_DECL_ASSIGN else variable fd
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable fd
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovl rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if15
	jmp .end_if15
.if15:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str6
	mov rdx, 19
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, -1
	add rsp, 16
	jmp .exit
	jmp .end_if15
.end_if15:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-8]; printExpression variable fd
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
	mov qword [rbp-16], rax; VAR_DECL_ASSIGN else variable size
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable size
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if16
	jmp .end_if16
.if16:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str7
	mov rdx, 24
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, -1
	add rsp, 16
	jmp .exit
	jmp .end_if16
.end_if16:
	mov rax, qword [rbp-16]; printExpression variable size
	mov rdi, rax
	call Setup
	call Part1
	mov rax, 0
	mov rdi, rax
	add rsp, 16
.exit:
	mov rax, 60
	syscall
