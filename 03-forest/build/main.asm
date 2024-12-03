section .data
	Array_OOB: db "Array index out of bounds!",0xA,0
	str0: db 109,117,108,40,0
	str1: db 83,117,109,32,111,102,32,109,117,108,116,115,32,112,97,114,116,32,49,58,32,0
	str2: db 100,111,110,39,116,40,41,0
	str3: db 100,111,40,41,0
	str4: db 83,117,109,32,111,102,32,109,117,108,116,115,32,112,97,114,116,32,50,58,32,0
	str5: db 67,111,117,108,100,32,110,111,116,32,111,112,101,110,32,102,105,108,101,0
	str6: db 67,111,117,108,100,32,110,111,116,32,114,101,97,100,32,102,114,111,109,32,102,105,108,101,0
	s_num_count dq 0
section .bss
	s_buffer resb 20000
	s_num1 resq 2000
	s_num2 resq 2000

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

global StrEquals
StrEquals:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 24
	mov qword [rbp-8], rdi
	mov qword [rbp-16], rsi
	mov qword [rbp-24], rdx
	sub rsp, 24
	mov rax, qword [rbp-24]; printExpression variable len
	mov qword [rbp-32], rax; VAR_DECL_ASSIGN else variable length
	mov rax, 0
	mov qword [rbp-40], rax; LOOP i
.label1:
	mov rax, qword [rbp-32]; printExpression variable length
	cmp qword [rbp-40], rax; LOOP i
	jl .inside_label1
	jmp .not_label1
.inside_label1:
	mov rax, qword [rbp-40]; printExpression variable i
	mov rbx, 1
	mul rbx
	mov rbx, qword [rbp-8]
	add rax, rbx
	movzx r11, byte [rax]; printExpression ref s1
	mov rax, r11
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-40]; printExpression variable i
	mov rbx, 1
	mul rbx
	mov rbx, qword [rbp-16]
	add rax, rbx
	movzx r11, byte [rax]; printExpression ref s2
	mov rbx, r11; printExpression, nodeType=1, ref index
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovne rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if1
	jmp .end_if1
.if1:
	mov rax, 0
	add rsp, 24
	jmp .exit
	jmp .end_if1
.end_if1:
.skip_label1:
	mov rax, qword [rbp-40]; LOOP i
	inc rax
	mov qword [rbp-40], rax; LOOP i
	jmp .label1
.not_label1:
	mov rax, 1
	add rsp, 24
	jmp .exit
	add rsp, 24
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

global GetMul
GetMul:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 16
	mov qword [rbp-8], rdi
	mov qword [rbp-16], rsi
	sub rsp, 24
	mov rax, 0
	mov byte [rbp-17], al; VAR_DECL_ASSIGN else variable returnVal
	mov rax, qword [rbp-16]; printExpression variable offset
	mov qword [rbp-25], rax; LOOP i
.label2:
	mov rax, qword [rbp-8]; printExpression variable size
	cmp qword [rbp-25], rax; LOOP i
	jl .inside_label2
	jmp .not_label2
.inside_label2:
	sub rsp, 16
	mov rax, qword [rbp-25]; printExpression variable i
	cmp rax, 20000; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-26], al; VAR_DECL_ASSIGN else variable byte
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	lea rax, [s_buffer]; printExpression variable s_buffer
	push rax; printExpression, leftPrinted, save left
	mov rbx, qword [rbp-25]; printExpression, right identifier, rbp variable i
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov rdi, rax
	mov rsi, str0
	mov rax, 4
	mov rdx, rax
	call StrEquals
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov byte [rbp-27], al; VAR_DECL_ASSIGN else variable isMul
	movzx rax, byte [rbp-27]; printExpression !isMul
	xor rax, 1
	test rax, rax
	jnz .if2
	jmp .end_if2
.if2:
	mov rax, 0
	add rsp, 40
	jmp .exit
	jmp .end_if2
.end_if2:
	mov rax, qword [rbp-25]; printExpression, left identifier, rbp variable i
	mov rbx, 4; printExpression, right int
	add rax, rbx
	mov qword [rbp-25], rax; VAR_ASSIGNMENT else variable i
	mov rax, qword [rbp-25]; printExpression variable i
	cmp rax, 20000; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-28], al; VAR_DECL_ASSIGN else variable numByte
	movzx rax, byte [rbp-28]; printExpression, left identifier, rbp variable numByte
	mov rbx, 48; printExpression, right char '0'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovl rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-28]; printExpression, left identifier, rbp variable numByte
	mov rbx, 57; printExpression, right char '9'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovg rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	or ax, bx
	test rax, rax
	jnz .if3
	jmp .end_if3
.if3:
	mov rax, 0
	add rsp, 40
	jmp .exit
	jmp .end_if3
.end_if3:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	lea rax, [s_buffer]; printExpression variable s_buffer
	push rax; printExpression, leftPrinted, save left
	mov rbx, qword [rbp-25]; printExpression, right identifier, rbp variable i
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov rdi, rax
	call find_ui64_in_string
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov qword [rbp-36], rax; VAR_DECL_ASSIGN else variable num
	mov rax, 0
	mov byte [rbp-37], al; VAR_DECL_ASSIGN else variable numLength
	mov rax, qword [s_num_count]; printExpression global variable s_num_count
	cmp rax, 2000; check bounds
	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-36]; printExpression variable num
	pop r11
	mov qword [s_num1+r11*8], rax; VAR_ASSIGNMENT ARRAY s_num1
	mov rax, 0
	mov byte [rbp-38], al; LOOP j
.label3:
	mov rax, 20
	cmp byte [rbp-38], al; LOOP j
	jl .inside_label3
	jmp .not_label3
.inside_label3:
	mov rax, qword [rbp-25]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-38]; printExpression, right identifier, rbp variable j
	add rax, rbx
	cmp rax, 20000; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-28], al; VAR_ASSIGNMENT else variable numByte
	movzx rax, byte [rbp-28]; printExpression, left identifier, rbp variable numByte
	mov rbx, 48; printExpression, right char '0'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-28]; printExpression, left identifier, rbp variable numByte
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
	jnz .if4
	jmp .else_if4
.if4:
	movzx rax, byte [rbp-37]; printExpression, left identifier, rbp variable numLength
	mov rbx, 1; printExpression, right int
	add al, bl
	mov byte [rbp-37], al; VAR_ASSIGNMENT else variable numLength
	jmp .end_if4
.else_if4:
	jmp .not_label3
.end_if4:
.skip_label3:
	mov al, byte [rbp-38]; LOOP j
	inc rax
	mov byte [rbp-38], al; LOOP j
	jmp .label3
.not_label3:
	mov rax, qword [rbp-25]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-37]; printExpression, right identifier, rbp variable numLength
	add rax, rbx
	mov qword [rbp-25], rax; VAR_ASSIGNMENT else variable i
	mov rax, qword [rbp-25]; printExpression variable i
	cmp rax, 20000; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-26], al; VAR_ASSIGNMENT else variable byte
	movzx rax, byte [rbp-26]; printExpression, left identifier, rbp variable byte
	mov rbx, 44; printExpression, right char ','
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovne rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if5
	jmp .end_if5
.if5:
	mov rax, 0
	add rsp, 40
	jmp .exit
	jmp .end_if5
.end_if5:
	mov rax, qword [rbp-25]; printExpression, left identifier, rbp variable i
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-25], rax; VAR_ASSIGNMENT else variable i
	mov rax, qword [rbp-25]; printExpression variable i
	cmp rax, 20000; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-28], al; VAR_ASSIGNMENT else variable numByte
	movzx rax, byte [rbp-28]; printExpression, left identifier, rbp variable numByte
	mov rbx, 48; printExpression, right char '0'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovl rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-28]; printExpression, left identifier, rbp variable numByte
	mov rbx, 57; printExpression, right char '9'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovg rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	or ax, bx
	test rax, rax
	jnz .if6
	jmp .end_if6
.if6:
	mov rax, 0
	add rsp, 40
	jmp .exit
	jmp .end_if6
.end_if6:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	lea rax, [s_buffer]; printExpression variable s_buffer
	push rax; printExpression, leftPrinted, save left
	mov rbx, qword [rbp-25]; printExpression, right identifier, rbp variable i
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov rdi, rax
	call find_ui64_in_string
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov qword [rbp-36], rax; VAR_ASSIGNMENT else variable num
	mov rax, 0
	mov byte [rbp-37], al; VAR_ASSIGNMENT else variable numLength
	mov rax, 0
	mov byte [rbp-39], al; LOOP j
.label4:
	mov rax, 20
	cmp byte [rbp-39], al; LOOP j
	jl .inside_label4
	jmp .not_label4
.inside_label4:
	mov rax, qword [rbp-25]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-39]; printExpression, right identifier, rbp variable j
	add rax, rbx
	cmp rax, 20000; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-28], al; VAR_ASSIGNMENT else variable numByte
	movzx rax, byte [rbp-28]; printExpression, left identifier, rbp variable numByte
	mov rbx, 48; printExpression, right char '0'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-28]; printExpression, left identifier, rbp variable numByte
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
	jnz .if7
	jmp .else_if7
.if7:
	movzx rax, byte [rbp-37]; printExpression, left identifier, rbp variable numLength
	mov rbx, 1; printExpression, right int
	add al, bl
	mov byte [rbp-37], al; VAR_ASSIGNMENT else variable numLength
	jmp .end_if7
.else_if7:
	jmp .not_label4
.end_if7:
.skip_label4:
	mov al, byte [rbp-39]; LOOP j
	inc rax
	mov byte [rbp-39], al; LOOP j
	jmp .label4
.not_label4:
	mov rax, qword [rbp-25]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-37]; printExpression, right identifier, rbp variable numLength
	add rax, rbx
	mov qword [rbp-25], rax; VAR_ASSIGNMENT else variable i
	mov rax, qword [rbp-25]; printExpression variable i
	cmp rax, 20000; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-26], al; VAR_ASSIGNMENT else variable byte
	movzx rax, byte [rbp-26]; printExpression, left identifier, rbp variable byte
	mov rbx, 41; printExpression, right char ')'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovne rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if8
	jmp .end_if8
.if8:
	mov rax, 0
	add rsp, 40
	jmp .exit
	jmp .end_if8
.end_if8:
	mov rax, qword [s_num_count]; printExpression global variable s_num_count
	cmp rax, 2000; check bounds
	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-36]; printExpression variable num
	pop r11
	mov qword [s_num2+r11*8], rax; VAR_ASSIGNMENT ARRAY s_num2
	mov rax, qword [s_num_count]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [s_num_count], rax; VAR_ASSIGNMENT else variable s_num_count
	mov rax, qword [rbp-25]; printExpression, left identifier, rbp variable i
	mov rbx, qword [rbp-16]; printExpression, right identifier, rbp variable offset
	sub rax, rbx
	mov byte [rbp-17], al; VAR_ASSIGNMENT else variable returnVal
	jmp .not_label2
	add rsp, 16
.skip_label2:
	mov rax, qword [rbp-25]; LOOP i
	inc rax
	mov qword [rbp-25], rax; LOOP i
	jmp .label2
.not_label2:
	movzx rax, byte [rbp-17]; printExpression variable returnVal
	add rsp, 24
	jmp .exit
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
	sub rsp, 8
	mov qword [rbp-8], rdi
	sub rsp, 40
	mov rax, 0
	mov qword [rbp-16], rax; VAR_DECL_ASSIGN else variable sum
	mov rax, 0
	mov qword [rbp-24], rax; LOOP i
.label5:
	mov rax, qword [rbp-8]; printExpression variable size
	cmp qword [rbp-24], rax; LOOP i
	jl .inside_label5
	jmp .not_label5
.inside_label5:
	sub rsp, 8
	mov rax, qword [rbp-24]; printExpression variable i
	cmp rax, 20000; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-25], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable byte
	mov rbx, 109; printExpression, right char 'm'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if9
	jmp .end_if9
.if9:
	sub rsp, 8
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-8]; printExpression variable size
	mov rdi, rax
	mov rax, qword [rbp-24]; printExpression variable i
	mov rsi, rax
	call GetMul
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov byte [rbp-26], al; VAR_DECL_ASSIGN else variable offset
	movzx rax, byte [rbp-26]; printExpression, left identifier, rbp variable offset
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if10
	jmp .end_if10
.if10:
	jmp .skip_label5
	jmp .end_if10
.end_if10:
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-26]; printExpression, right identifier, rbp variable offset
	add rax, rbx
	mov qword [rbp-24], rax; VAR_ASSIGNMENT else variable i
	add rsp, 8
	jmp .end_if9
.end_if9:
	add rsp, 8
.skip_label5:
	mov rax, qword [rbp-24]; LOOP i
	inc rax
	mov qword [rbp-24], rax; LOOP i
	jmp .label5
.not_label5:
	mov rax, 0
	mov qword [rbp-32], rax; LOOP i
.label6:
	mov rax, qword [s_num_count]; printExpression global variable s_num_count
	cmp qword [rbp-32], rax; LOOP i
	jl .inside_label6
	jmp .not_label6
.inside_label6:
	sub rsp, 40
	mov rax, qword [rbp-32]; printExpression variable i
	cmp rax, 2000; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_num1+rax*8]; printExpression array s_num1
	mov rax, r12
	mov qword [rbp-40], rax; VAR_DECL_ASSIGN else variable num1
	mov rax, qword [rbp-32]; printExpression variable i
	cmp rax, 2000; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_num2+rax*8]; printExpression array s_num2
	mov rax, r12
	mov qword [rbp-48], rax; VAR_DECL_ASSIGN else variable num2
	mov rax, qword [rbp-40]; printExpression, left identifier, rbp variable num1
	mov rbx, qword [rbp-48]; printExpression, right identifier, rbp variable num2
	mul qword rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable sum
	add rax, rbx
	mov qword [rbp-16], rax; VAR_ASSIGNMENT else variable sum
	add rsp, 40
.skip_label6:
	mov rax, qword [rbp-32]; LOOP i
	inc rax
	mov qword [rbp-32], rax; LOOP i
	jmp .label6
.not_label6:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str1
	mov rdx, 21
	syscall
; =============== END FUNC CALL + STRING ===============
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-16]; variable sum
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
	add rsp, 40
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
	sub rsp, 40
	mov rax, 0
	mov qword [rbp-16], rax; VAR_DECL_ASSIGN else variable sum
	mov rax, 0
	mov qword [rbp-24], rax; VAR_DECL_ASSIGN else variable iter
	mov rax, 1
	mov byte [rbp-25], al; VAR_DECL_ASSIGN else variable enabled
	mov rax, 0
	mov qword [rbp-33], rax; LOOP i
.label7:
	mov rax, qword [rbp-8]; printExpression variable size
	cmp qword [rbp-33], rax; LOOP i
	jl .inside_label7
	jmp .not_label7
.inside_label7:
	sub rsp, 8
	mov rax, qword [rbp-33]; printExpression variable i
	cmp rax, 20000; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-34], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-34]; printExpression, left identifier, rbp variable byte
	mov rbx, 100; printExpression, right char 'd'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if11
	jmp .else_if11
.if11:
	sub rsp, 8
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	lea rax, [s_buffer]; printExpression variable s_buffer
	push rax; printExpression, leftPrinted, save left
	mov rbx, qword [rbp-33]; printExpression, right identifier, rbp variable i
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov rdi, rax
	mov rsi, str2
	mov rax, 7
	mov rdx, rax
	call StrEquals
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov byte [rbp-35], al; VAR_DECL_ASSIGN else variable matchesDont
	movzx rax, byte [rbp-35]; printExpression variable matchesDont
	test rax, rax
	jnz .if12
	jmp .end_if12
.if12:
	mov rax, 0
	mov byte [rbp-25], al; VAR_ASSIGNMENT else variable enabled
	jmp .skip_label7
	jmp .end_if12
.end_if12:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	lea rax, [s_buffer]; printExpression variable s_buffer
	push rax; printExpression, leftPrinted, save left
	mov rbx, qword [rbp-33]; printExpression, right identifier, rbp variable i
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov rdi, rax
	mov rsi, str3
	mov rax, 4
	mov rdx, rax
	call StrEquals
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov byte [rbp-36], al; VAR_DECL_ASSIGN else variable matchesDo
	movzx rax, byte [rbp-36]; printExpression variable matchesDo
	test rax, rax
	jnz .if13
	jmp .end_if13
.if13:
	mov rax, 1
	mov byte [rbp-25], al; VAR_ASSIGNMENT else variable enabled
	jmp .skip_label7
	jmp .end_if13
.end_if13:
	add rsp, 8
	jmp .end_if11
.else_if11:
	movzx rax, byte [rbp-34]; printExpression, left identifier, rbp variable byte
	mov rbx, 109; printExpression, right char 'm'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if14
	jmp .end_if14
.if14:
	sub rsp, 24
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-8]; printExpression variable size
	mov rdi, rax
	mov rax, qword [rbp-33]; printExpression variable i
	mov rsi, rax
	call GetMul
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov byte [rbp-35], al; VAR_DECL_ASSIGN else variable offset
	movzx rax, byte [rbp-35]; printExpression, left identifier, rbp variable offset
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if15
	jmp .end_if15
.if15:
	jmp .skip_label7
	jmp .end_if15
.end_if15:
	mov rax, qword [rbp-24]; printExpression variable iter
	cmp rax, 2000; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_num1+rax*8]; printExpression array s_num1
	mov rax, r12
	mov qword [rbp-43], rax; VAR_DECL_ASSIGN else variable num1
	mov rax, qword [rbp-24]; printExpression variable iter
	cmp rax, 2000; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_num2+rax*8]; printExpression array s_num2
	mov rax, r12
	mov qword [rbp-51], rax; VAR_DECL_ASSIGN else variable num2
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp variable iter
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-24], rax; VAR_ASSIGNMENT else variable iter
	movzx rax, byte [rbp-25]; printExpression variable enabled
	test rax, rax
	jnz .if16
	jmp .end_if16
.if16:
	mov rax, qword [rbp-43]; printExpression, left identifier, rbp variable num1
	mov rbx, qword [rbp-51]; printExpression, right identifier, rbp variable num2
	mul qword rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable sum
	add rax, rbx
	mov qword [rbp-16], rax; VAR_ASSIGNMENT else variable sum
	jmp .end_if16
.end_if16:
	mov rax, qword [rbp-33]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-35]; printExpression, right identifier, rbp variable offset
	add rax, rbx
	mov qword [rbp-33], rax; VAR_ASSIGNMENT else variable i
	add rsp, 24
	jmp .end_if14
.end_if14:
.end_if11:
	add rsp, 8
.skip_label7:
	mov rax, qword [rbp-33]; LOOP i
	inc rax
	mov qword [rbp-33], rax; LOOP i
	jmp .label7
.not_label7:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str4
	mov rdx, 21
	syscall
; =============== END FUNC CALL + STRING ===============
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-16]; variable sum
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
	add rsp, 40
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
	jnz .if17
	jmp .end_if17
.if17:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str5
	mov rdx, 19
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, -1
	add rsp, 16
	jmp .exit
	jmp .end_if17
.end_if17:
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
	jnz .if18
	jmp .end_if18
.if18:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str6
	mov rdx, 24
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, -1
	add rsp, 16
	jmp .exit
	jmp .end_if18
.end_if18:
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
