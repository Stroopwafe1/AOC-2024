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
	s_start_x dq 0
	s_start_y dq 0
	s_visited_count dq 0
	s_width dq 0
section .bss
	s_buffer resb 20000
	s_visited_x resq 10000
	s_visited_y resq 10000

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

global Hash
Hash:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 8
	mov word [rbp-2], di
	mov word [rbp-4], si
	movzx rax, word [rbp-2]; printExpression, left identifier, rbp variable a
	mov rbx, 16; printExpression, right int
	mov rcx, rbx; printExpression, shift left
	shl rax, cl
	push rax; printExpression, leftPrinted, save left
	movzx rbx, word [rbp-4]; printExpression, right identifier, rbp variable b
	pop rax; printExpression, leftPrinted, recover left
	add ax, bx
	jmp .exit
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

global Setup
Setup:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 8
	mov qword [rbp-8], rdi
	sub rsp, 32
	mov rax, 0
	mov qword [rbp-16], rax; VAR_DECL_ASSIGN else variable y
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, 2147483647
	mov rdi, rax
	mov rax, 9
	mov rsi, rdi
	xor rdi, rdi
	mov rdx, 3
	mov r10, 34
	xor r8, r8
	xor r9, r9
	syscall
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov qword [rbp-24], rax; VAR_DECL_ASSIGN else variable hashBuffer
	mov rax, 0
	mov qword [rbp-32], rax; LOOP i
.label1:
	mov rax, qword [rbp-8]; printExpression variable size
	cmp qword [rbp-32], rax; LOOP i
	jl .inside_label1
	jmp .not_label1
.inside_label1:
	sub rsp, 8
	mov rax, qword [rbp-32]; printExpression variable i
	cmp rax, 20000; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-33], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-33]; printExpression, left identifier, rbp variable byte
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
	mov rax, qword [rbp-32]; printExpression variable i
	mov qword [s_width], rax; VAR_ASSIGNMENT else variable s_width
	jmp .end_if2
.end_if2:
	jmp .end_if1
.else_if1:
	movzx rax, byte [rbp-33]; printExpression, left identifier, rbp variable byte
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
	sub rsp, 24
	mov rax, qword [rbp-32]; printExpression variable i
	mov word [rbp-35], ax; VAR_DECL_ASSIGN else variable x
	mov rax, qword [s_width]; printExpression, left identifier, not rbp
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovne rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if4
	jmp .end_if4
.if4:
	mov rax, qword [s_width]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-32]; printExpression, left identifier, rbp variable i
	cqo
	xor rdx, rdx; Clearing rdx for division
	idiv rax, rbx
	mov rax, rdx
	mov word [rbp-35], ax; VAR_ASSIGNMENT else variable x
	jmp .end_if4
.end_if4:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	movzx rax, word [rbp-35]; printExpression variable x
	mov rdi, rax
	mov rax, qword [rbp-16]; printExpression variable y
	mov rsi, rax
	call Hash
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov dword [rbp-39], eax; VAR_DECL_ASSIGN else variable index
	mov eax, dword [rbp-39]; printExpression variable index
	lea r11, byte [rbp-24]
	mov r11, qword [r11]
	mov rbx, 1
	mul rbx
	add r11, rax
	push r11
	mov rax, 1
	pop r11
	mov byte [r11], al; VAR_ASSIGNMENT REF hashBuffer
	add rsp, 24
	jmp .end_if3
.else_if3:
	movzx rax, byte [rbp-33]; printExpression, left identifier, rbp variable byte
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
	mov rax, qword [rbp-32]; printExpression, left identifier, rbp variable i
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
	mov rax, qword [rbp-32]; LOOP i
	inc rax
	mov qword [rbp-32], rax; LOOP i
	jmp .label1
.not_label1:
	mov rax, qword [rbp-24]; printExpression variable hashBuffer
	add rsp, 32
	jmp .exit
	add rsp, 32
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
	mov rax, qword [s_start_x]; printExpression global variable s_start_x
	mov qword [rbp-16], rax; VAR_DECL_ASSIGN else variable x
	mov rax, qword [s_start_y]; printExpression global variable s_start_y
	mov qword [rbp-24], rax; VAR_DECL_ASSIGN else variable y
	mov rax, 0
	mov byte [rbp-25], al; VAR_DECL_ASSIGN else variable x_dir
	mov rax, -1
	mov byte [rbp-26], al; VAR_DECL_ASSIGN else variable y_dir
	mov rax, qword [s_visited_count]; printExpression global variable s_visited_count
	cmp rax, 10000; check bounds
	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-16]; printExpression variable x
	pop r11
	mov qword [s_visited_x+r11*8], rax; VAR_ASSIGNMENT ARRAY s_visited_x
	mov rax, qword [s_visited_count]; printExpression global variable s_visited_count
	cmp rax, 10000; check bounds
	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-24]; printExpression variable y
	pop r11
	mov qword [s_visited_y+r11*8], rax; VAR_ASSIGNMENT ARRAY s_visited_y
	mov rax, qword [s_visited_count]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [s_visited_count], rax; VAR_ASSIGNMENT else variable s_visited_count
.label2:
	sub rsp, 32
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable x
	movsx rbx, byte [rbp-25]; printExpression, right identifier, rbp variable x_dir
	add rax, rbx
	mov qword [rbp-34], rax; VAR_DECL_ASSIGN else variable x_next
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp variable y
	movsx rbx, byte [rbp-26]; printExpression, right identifier, rbp variable y_dir
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
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-34]; printExpression variable x_next
	mov rdi, rax
	mov rax, qword [rbp-42]; printExpression variable y_next
	mov rsi, rax
	call Hash
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov dword [rbp-47], eax; VAR_DECL_ASSIGN else variable hash
	mov eax, dword [rbp-47]; printExpression variable hash
	mov rbx, 1
	mul rbx
	mov rbx, qword [rbp-8]
	add rax, rbx
	movzx r11, byte [rax]; printExpression ref hashBuffer
	mov rax, r11
	mov byte [rbp-48], al; VAR_DECL_ASSIGN else variable hasPos
	movzx rax, byte [rbp-48]; printExpression, left identifier, rbp variable hasPos
	mov rbx, 1; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if8
	jmp .end_if8
.if8:
	movsx rax, byte [rbp-26]; printExpression, left identifier, rbp variable y_dir
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
	mov byte [rbp-26], al; VAR_ASSIGNMENT else variable y_dir
	mov rax, 1
	mov byte [rbp-25], al; VAR_ASSIGNMENT else variable x_dir
	jmp .end_if9
.else_if9:
	movsx rax, byte [rbp-25]; printExpression, left identifier, rbp variable x_dir
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
	mov byte [rbp-25], al; VAR_ASSIGNMENT else variable x_dir
	mov rax, 1
	mov byte [rbp-26], al; VAR_ASSIGNMENT else variable y_dir
	jmp .end_if10
.else_if10:
	movsx rax, byte [rbp-26]; printExpression, left identifier, rbp variable y_dir
	mov rbx, 1; printExpression, right int
	test rax, rax
	jnz .if11
	jmp .else_if11
.if11:
	mov rax, 0
	mov byte [rbp-26], al; VAR_ASSIGNMENT else variable y_dir
	mov rax, -1
	mov byte [rbp-25], al; VAR_ASSIGNMENT else variable x_dir
	jmp .end_if11
.else_if11:
	mov rax, 0
	mov byte [rbp-25], al; VAR_ASSIGNMENT else variable x_dir
	mov rax, -1
	mov byte [rbp-26], al; VAR_ASSIGNMENT else variable y_dir
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
	mov rdi, qword [rbp-16]; variable x
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
	mov rdi, qword [rbp-24]; variable y
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
	jmp .end_if8
.end_if8:
	movzx rax, byte [rbp-43]; printExpression variable turned
	test rax, rax
	jnz .if12
	jmp .end_if12
.if12:
	jmp .skip_label2
	jmp .end_if12
.end_if12:
	mov rax, qword [rbp-34]; printExpression variable x_next
	mov qword [rbp-16], rax; VAR_ASSIGNMENT else variable x
	mov rax, qword [rbp-42]; printExpression variable y_next
	mov qword [rbp-24], rax; VAR_ASSIGNMENT else variable y
	mov rax, 0
	mov byte [rbp-49], al; VAR_DECL_ASSIGN else variable alreadyAdded
	mov rax, 0
	mov qword [rbp-57], rax; LOOP i
.label3:
	mov rax, qword [s_visited_count]; printExpression global variable s_visited_count
	cmp qword [rbp-57], rax; LOOP i
	jl .inside_label3
	jmp .not_label3
.inside_label3:
	sub rsp, 16
	mov rax, qword [rbp-57]; printExpression variable i
	cmp rax, 10000; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_visited_x+rax*8]; printExpression array s_visited_x
	mov rax, r12
	mov qword [rbp-65], rax; VAR_DECL_ASSIGN else variable x_check
	mov rax, qword [rbp-57]; printExpression variable i
	cmp rax, 10000; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_visited_y+rax*8]; printExpression array s_visited_y
	mov rax, r12
	mov qword [rbp-73], rax; VAR_DECL_ASSIGN else variable y_check
	mov rax, qword [rbp-65]; printExpression, left identifier, rbp variable x_check
	mov rbx, qword [rbp-16]; printExpression, right identifier, rbp variable x
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-73]; printExpression, left identifier, rbp variable y_check
	mov rbx, qword [rbp-24]; printExpression, right identifier, rbp variable y
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
	mov byte [rbp-49], al; VAR_ASSIGNMENT else variable alreadyAdded
	jmp .not_label3
	jmp .end_if13
.end_if13:
	add rsp, 16
.skip_label3:
	mov rax, qword [rbp-57]; LOOP i
	inc rax
	mov qword [rbp-57], rax; LOOP i
	jmp .label3
.not_label3:
	movzx rax, byte [rbp-49]; printExpression !alreadyAdded
	xor rax, 1
	test rax, rax
	jnz .if14
	jmp .end_if14
.if14:
	mov rax, qword [s_visited_count]; printExpression global variable s_visited_count
	cmp rax, 10000; check bounds
	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-16]; printExpression variable x
	pop r11
	mov qword [s_visited_x+r11*8], rax; VAR_ASSIGNMENT ARRAY s_visited_x
	mov rax, qword [s_visited_count]; printExpression global variable s_visited_count
	cmp rax, 10000; check bounds
	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-24]; printExpression variable y
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
	add rsp, 24
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

global SimulateGame
SimulateGame:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 8
	mov qword [rbp-8], rdi
	sub rsp, 32
	mov rax, qword [s_start_x]; printExpression global variable s_start_x
	mov qword [rbp-16], rax; VAR_DECL_ASSIGN else variable x
	mov rax, qword [s_start_y]; printExpression global variable s_start_y
	mov qword [rbp-24], rax; VAR_DECL_ASSIGN else variable y
	mov rax, 0
	mov byte [rbp-25], al; VAR_DECL_ASSIGN else variable x_dir
	mov rax, -1
	mov byte [rbp-26], al; VAR_DECL_ASSIGN else variable y_dir
	mov rax, 0
	mov word [rbp-28], ax; LOOP end
.label4:
	mov rax, 6000
	cmp word [rbp-28], ax; LOOP end
	jl .inside_label4
	jmp .not_label4
.inside_label4:
	sub rsp, 24
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable x
	movsx rbx, byte [rbp-25]; printExpression, right identifier, rbp variable x_dir
	add rax, rbx
	mov qword [rbp-36], rax; VAR_DECL_ASSIGN else variable x_next
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp variable y
	movsx rbx, byte [rbp-26]; printExpression, right identifier, rbp variable y_dir
	add rax, rbx
	mov qword [rbp-44], rax; VAR_DECL_ASSIGN else variable y_next
	mov rax, 0
	mov byte [rbp-45], al; VAR_DECL_ASSIGN else variable turned
	mov rax, qword [rbp-36]; printExpression, left identifier, rbp variable x_next
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovl rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-36]; printExpression, left identifier, rbp variable x_next
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
	jnz .if15
	jmp .else_if15
.if15:
	mov rax, 0
	add rsp, 56
	jmp .exit
	jmp .end_if15
.else_if15:
	mov rax, qword [rbp-44]; printExpression, left identifier, rbp variable y_next
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovl rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-44]; printExpression, left identifier, rbp variable y_next
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
	jnz .if16
	jmp .end_if16
.if16:
	mov rax, 0
	add rsp, 56
	jmp .exit
	jmp .end_if16
.end_if16:
.end_if15:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-36]; printExpression variable x_next
	mov rdi, rax
	mov rax, qword [rbp-44]; printExpression variable y_next
	mov rsi, rax
	call Hash
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov dword [rbp-49], eax; VAR_DECL_ASSIGN else variable hash
	mov eax, dword [rbp-49]; printExpression variable hash
	mov rbx, 1
	mul rbx
	mov rbx, qword [rbp-8]
	add rax, rbx
	movzx r11, byte [rax]; printExpression ref hashBuffer
	mov rax, r11
	mov byte [rbp-50], al; VAR_DECL_ASSIGN else variable hasPos
	movzx rax, byte [rbp-50]; printExpression, left identifier, rbp variable hasPos
	mov rbx, 1; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if17
	jmp .end_if17
.if17:
	movsx rax, byte [rbp-26]; printExpression, left identifier, rbp variable y_dir
	mov rbx, -1; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if18
	jmp .else_if18
.if18:
	mov rax, 0
	mov byte [rbp-26], al; VAR_ASSIGNMENT else variable y_dir
	mov rax, 1
	mov byte [rbp-25], al; VAR_ASSIGNMENT else variable x_dir
	jmp .end_if18
.else_if18:
	movsx rax, byte [rbp-25]; printExpression, left identifier, rbp variable x_dir
	mov rbx, 1; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if19
	jmp .else_if19
.if19:
	mov rax, 0
	mov byte [rbp-25], al; VAR_ASSIGNMENT else variable x_dir
	mov rax, 1
	mov byte [rbp-26], al; VAR_ASSIGNMENT else variable y_dir
	jmp .end_if19
.else_if19:
	movsx rax, byte [rbp-26]; printExpression, left identifier, rbp variable y_dir
	mov rbx, 1; printExpression, right int
	test rax, rax
	jnz .if20
	jmp .else_if20
.if20:
	mov rax, 0
	mov byte [rbp-26], al; VAR_ASSIGNMENT else variable y_dir
	mov rax, -1
	mov byte [rbp-25], al; VAR_ASSIGNMENT else variable x_dir
	jmp .end_if20
.else_if20:
	mov rax, 0
	mov byte [rbp-25], al; VAR_ASSIGNMENT else variable x_dir
	mov rax, -1
	mov byte [rbp-26], al; VAR_ASSIGNMENT else variable y_dir
.end_if20:
.end_if19:
.end_if18:
	mov rax, 1
	mov byte [rbp-45], al; VAR_ASSIGNMENT else variable turned
	jmp .end_if17
.end_if17:
	movzx rax, byte [rbp-45]; printExpression variable turned
	test rax, rax
	jnz .if21
	jmp .end_if21
.if21:
	jmp .skip_label4
	jmp .end_if21
.end_if21:
	mov rax, qword [rbp-36]; printExpression variable x_next
	mov qword [rbp-16], rax; VAR_ASSIGNMENT else variable x
	mov rax, qword [rbp-44]; printExpression variable y_next
	mov qword [rbp-24], rax; VAR_ASSIGNMENT else variable y
	add rsp, 24
.skip_label4:
	mov ax, word [rbp-28]; LOOP end
	inc rax
	mov word [rbp-28], ax; LOOP end
	jmp .label4
.not_label4:
	mov rax, 1
	add rsp, 32
	jmp .exit
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
	sub rsp, 8
	mov qword [rbp-8], rdi
	sub rsp, 24
	mov rax, 0
	mov qword [rbp-16], rax; VAR_DECL_ASSIGN else variable sum
	mov rax, 1
	mov qword [rbp-24], rax; LOOP i
.label5:
	mov rax, qword [s_visited_count]; printExpression global variable s_visited_count
	cmp qword [rbp-24], rax; LOOP i
	jl .inside_label5
	jmp .not_label5
.inside_label5:
	sub rsp, 24
	mov rax, qword [rbp-24]; printExpression variable i
	cmp rax, 10000; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_visited_x+rax*8]; printExpression array s_visited_x
	mov rax, r12
	mov qword [rbp-32], rax; VAR_DECL_ASSIGN else variable x
	mov rax, qword [rbp-24]; printExpression variable i
	cmp rax, 10000; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_visited_y+rax*8]; printExpression array s_visited_y
	mov rax, r12
	mov qword [rbp-40], rax; VAR_DECL_ASSIGN else variable y
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-32]; printExpression variable x
	mov rdi, rax
	mov rax, qword [rbp-40]; printExpression variable y
	mov rsi, rax
	call Hash
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov dword [rbp-44], eax; VAR_DECL_ASSIGN else variable index
	mov eax, dword [rbp-44]; printExpression variable index
	lea r11, byte [rbp-8]
	mov r11, qword [r11]
	mov rbx, 1
	mul rbx
	add r11, rax
	push r11
	mov rax, 1
	pop r11
	mov byte [r11], al; VAR_ASSIGNMENT REF hashBuffer
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-8]; printExpression variable hashBuffer
	mov rdi, rax
	call SimulateGame
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov byte [rbp-45], al; VAR_DECL_ASSIGN else variable result
	movzx rax, byte [rbp-45]; printExpression, left identifier, rbp variable result
	mov rbx, 1; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if22
	jmp .end_if22
.if22:
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable sum
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-16], rax; VAR_ASSIGNMENT else variable sum
	jmp .end_if22
.end_if22:
	mov eax, dword [rbp-44]; printExpression variable index
	lea r11, byte [rbp-8]
	mov r11, qword [r11]
	mov rbx, 1
	mul rbx
	add r11, rax
	push r11
	mov rax, 0
	pop r11
	mov byte [r11], al; VAR_ASSIGNMENT REF hashBuffer
	add rsp, 24
.skip_label5:
	mov rax, qword [rbp-24]; LOOP i
	inc rax
	mov qword [rbp-24], rax; LOOP i
	jmp .label5
.not_label5:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str5
	mov rdx, 8
	syscall
; =============== END FUNC CALL + STRING ===============
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-16]; variable sum
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
	sub rsp, 48
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
	jnz .if23
	jmp .end_if23
.if23:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str6
	mov rdx, 19
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, -1
	add rsp, 48
	jmp .exit
	jmp .end_if23
.end_if23:
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
	jnz .if24
	jmp .end_if24
.if24:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str7
	mov rdx, 24
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, -1
	add rsp, 48
	jmp .exit
	jmp .end_if24
.end_if24:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-16]; printExpression variable size
	mov rdi, rax
	call Setup
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov qword [rbp-24], rax; VAR_DECL_ASSIGN else variable hashBuffer
	mov rax, qword [rbp-24]; printExpression variable hashBuffer
	mov rdi, rax
	call Part1
	mov rax, qword [rbp-24]; printExpression variable hashBuffer
	mov rdi, rax
	call Part2
	mov rax, qword [rbp-24]; printExpression variable hashBuffer
	mov rdi, rax
	mov rax, 2147483647
	mov rsi, rax
	mov rax, 11
	syscall
	mov rax, 0
	mov rdi, rax
	add rsp, 48
.exit:
	mov rax, 60
	syscall
