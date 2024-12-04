section .data
	Array_OOB: db "Array index out of bounds!",0xA,0
	str0: db 32,105,115,32,120,109,97,115,32,98,97,99,107,119,97,114,100,115,10,0
	str1: db 32,105,115,32,120,109,97,115,32,102,111,114,119,97,114,100,115,10,0
	str2: db 32,105,115,32,120,109,97,115,32,100,111,119,110,10,0
	str3: db 32,105,115,32,120,109,97,115,32,117,112,10,0
	str4: db 32,105,115,32,120,109,97,115,32,78,87,10,0
	str5: db 32,105,115,32,120,109,97,115,32,78,69,10,0
	str6: db 32,105,115,32,120,109,97,115,32,83,69,10,0
	str7: db 32,105,115,32,120,109,97,115,32,83,87,10,0
	str8: db 80,97,114,116,32,49,58,32,0
	str9: db 80,97,114,116,32,50,58,32,0
	str10: db 67,111,117,108,100,32,110,111,116,32,111,112,101,110,32,102,105,108,101,0
	str11: db 67,111,117,108,100,32,110,111,116,32,114,101,97,100,32,102,114,111,109,32,102,105,108,101,0
section .bss
	s_buffer resb 20000

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

global GetChar
GetChar:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 16
	mov qword [rbp-8], rdi
	mov qword [rbp-16], rsi
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable index
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovl rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if1
	jmp .else_if1
.if1:
	mov rax, 0
	jmp .exit
	jmp .end_if1
.else_if1:
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable index
	mov rbx, qword [rbp-16]; printExpression, right identifier, rbp variable size
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovg rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if2
	jmp .end_if2
.if2:
	mov rax, 0
	jmp .exit
	jmp .end_if2
.end_if2:
.end_if1:
	mov rax, qword [rbp-8]; printExpression variable index
	cmp rax, 20000; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	jmp .exit
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

global IsXMASBackwards
IsXMASBackwards:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 16
	mov qword [rbp-8], rdi
	mov qword [rbp-16], rsi
	sub rsp, 8
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable index
	mov rbx, 1; printExpression, right int
	sub rax, rbx
	mov rdi, rax
	mov rax, qword [rbp-16]; printExpression variable size
	mov rsi, rax
	call GetChar
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	push rax; printExpression, leftPrinted, save left
	mov rbx, 77; printExpression, right char 'M'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov byte [rbp-17], al; VAR_DECL_ASSIGN else variable m
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable index
	mov rbx, 2; printExpression, right int
	sub rax, rbx
	mov rdi, rax
	mov rax, qword [rbp-16]; printExpression variable size
	mov rsi, rax
	call GetChar
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	push rax; printExpression, leftPrinted, save left
	mov rbx, 65; printExpression, right char 'A'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov byte [rbp-18], al; VAR_DECL_ASSIGN else variable a
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable index
	mov rbx, 3; printExpression, right int
	sub rax, rbx
	mov rdi, rax
	mov rax, qword [rbp-16]; printExpression variable size
	mov rsi, rax
	call GetChar
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	push rax; printExpression, leftPrinted, save left
	mov rbx, 83; printExpression, right char 'S'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov byte [rbp-19], al; VAR_DECL_ASSIGN else variable s
	movzx rax, byte [rbp-18]; printExpression, left identifier, rbp variable a
	movzx rbx, byte [rbp-19]; printExpression, right identifier, rbp variable s
	and al, bl
	mov rbx, rax; printExpression, nodeType=1
	movzx rax, byte [rbp-17]; printExpression, left identifier, rbp variable m
	and al, bl
	add rsp, 8
	jmp .exit
	add rsp, 8
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

global IsXMASForwards
IsXMASForwards:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 16
	mov qword [rbp-8], rdi
	mov qword [rbp-16], rsi
	sub rsp, 8
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable index
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov rdi, rax
	mov rax, qword [rbp-16]; printExpression variable size
	mov rsi, rax
	call GetChar
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	push rax; printExpression, leftPrinted, save left
	mov rbx, 77; printExpression, right char 'M'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov byte [rbp-17], al; VAR_DECL_ASSIGN else variable m
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable index
	mov rbx, 2; printExpression, right int
	add rax, rbx
	mov rdi, rax
	mov rax, qword [rbp-16]; printExpression variable size
	mov rsi, rax
	call GetChar
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	push rax; printExpression, leftPrinted, save left
	mov rbx, 65; printExpression, right char 'A'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov byte [rbp-18], al; VAR_DECL_ASSIGN else variable a
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable index
	mov rbx, 3; printExpression, right int
	add rax, rbx
	mov rdi, rax
	mov rax, qword [rbp-16]; printExpression variable size
	mov rsi, rax
	call GetChar
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	push rax; printExpression, leftPrinted, save left
	mov rbx, 83; printExpression, right char 'S'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov byte [rbp-19], al; VAR_DECL_ASSIGN else variable s
	movzx rax, byte [rbp-18]; printExpression, left identifier, rbp variable a
	movzx rbx, byte [rbp-19]; printExpression, right identifier, rbp variable s
	and al, bl
	mov rbx, rax; printExpression, nodeType=1
	movzx rax, byte [rbp-17]; printExpression, left identifier, rbp variable m
	and al, bl
	add rsp, 8
	jmp .exit
	add rsp, 8
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

global IsXMASDown
IsXMASDown:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 24
	mov qword [rbp-8], rdi
	mov qword [rbp-16], rsi
	mov qword [rbp-24], rdx
	sub rsp, 8
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, 1; printExpression, left int
	mov rbx, qword [rbp-16]; printExpression, right identifier, rbp variable length
	mul qword rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable index
	add rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov rdi, rax
	mov rax, qword [rbp-24]; printExpression variable size
	mov rsi, rax
	call GetChar
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	push rax; printExpression, leftPrinted, save left
	mov rbx, 77; printExpression, right char 'M'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov byte [rbp-25], al; VAR_DECL_ASSIGN else variable m
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, 2; printExpression, left int
	mov rbx, qword [rbp-16]; printExpression, right identifier, rbp variable length
	mul qword rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable index
	add rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 2; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov rdi, rax
	mov rax, qword [rbp-24]; printExpression variable size
	mov rsi, rax
	call GetChar
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	push rax; printExpression, leftPrinted, save left
	mov rbx, 65; printExpression, right char 'A'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov byte [rbp-26], al; VAR_DECL_ASSIGN else variable a
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, 3; printExpression, left int
	mov rbx, qword [rbp-16]; printExpression, right identifier, rbp variable length
	mul qword rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable index
	add rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 3; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov rdi, rax
	mov rax, qword [rbp-24]; printExpression variable size
	mov rsi, rax
	call GetChar
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	push rax; printExpression, leftPrinted, save left
	mov rbx, 83; printExpression, right char 'S'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov byte [rbp-27], al; VAR_DECL_ASSIGN else variable s
	movzx rax, byte [rbp-26]; printExpression, left identifier, rbp variable a
	movzx rbx, byte [rbp-27]; printExpression, right identifier, rbp variable s
	and al, bl
	mov rbx, rax; printExpression, nodeType=1
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable m
	and al, bl
	add rsp, 8
	jmp .exit
	add rsp, 8
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

global IsXMASUp
IsXMASUp:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 24
	mov qword [rbp-8], rdi
	mov qword [rbp-16], rsi
	mov qword [rbp-24], rdx
	sub rsp, 8
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, 1; printExpression, left int
	mov rbx, qword [rbp-16]; printExpression, right identifier, rbp variable length
	mul qword rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable index
	sub rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	sub rax, rbx
	mov rdi, rax
	mov rax, qword [rbp-24]; printExpression variable size
	mov rsi, rax
	call GetChar
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	push rax; printExpression, leftPrinted, save left
	mov rbx, 77; printExpression, right char 'M'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov byte [rbp-25], al; VAR_DECL_ASSIGN else variable m
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, 2; printExpression, left int
	mov rbx, qword [rbp-16]; printExpression, right identifier, rbp variable length
	mul qword rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable index
	sub rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 2; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	sub rax, rbx
	mov rdi, rax
	mov rax, qword [rbp-24]; printExpression variable size
	mov rsi, rax
	call GetChar
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	push rax; printExpression, leftPrinted, save left
	mov rbx, 65; printExpression, right char 'A'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov byte [rbp-26], al; VAR_DECL_ASSIGN else variable a
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, 3; printExpression, left int
	mov rbx, qword [rbp-16]; printExpression, right identifier, rbp variable length
	mul qword rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable index
	sub rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 3; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	sub rax, rbx
	mov rdi, rax
	mov rax, qword [rbp-24]; printExpression variable size
	mov rsi, rax
	call GetChar
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	push rax; printExpression, leftPrinted, save left
	mov rbx, 83; printExpression, right char 'S'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov byte [rbp-27], al; VAR_DECL_ASSIGN else variable s
	movzx rax, byte [rbp-26]; printExpression, left identifier, rbp variable a
	movzx rbx, byte [rbp-27]; printExpression, right identifier, rbp variable s
	and al, bl
	mov rbx, rax; printExpression, nodeType=1
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable m
	and al, bl
	add rsp, 8
	jmp .exit
	add rsp, 8
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

global IsXMASNW
IsXMASNW:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 24
	mov qword [rbp-8], rdi
	mov qword [rbp-16], rsi
	mov qword [rbp-24], rdx
	sub rsp, 8
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, 1; printExpression, left int
	mov rbx, qword [rbp-16]; printExpression, right identifier, rbp variable length
	mul qword rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable index
	sub rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 2; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	sub rax, rbx
	mov rdi, rax
	mov rax, qword [rbp-24]; printExpression variable size
	mov rsi, rax
	call GetChar
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	push rax; printExpression, leftPrinted, save left
	mov rbx, 77; printExpression, right char 'M'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov byte [rbp-25], al; VAR_DECL_ASSIGN else variable m
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, 2; printExpression, left int
	mov rbx, qword [rbp-16]; printExpression, right identifier, rbp variable length
	mul qword rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable index
	sub rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 4; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	sub rax, rbx
	mov rdi, rax
	mov rax, qword [rbp-24]; printExpression variable size
	mov rsi, rax
	call GetChar
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	push rax; printExpression, leftPrinted, save left
	mov rbx, 65; printExpression, right char 'A'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov byte [rbp-26], al; VAR_DECL_ASSIGN else variable a
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, 3; printExpression, left int
	mov rbx, qword [rbp-16]; printExpression, right identifier, rbp variable length
	mul qword rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable index
	sub rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 6; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	sub rax, rbx
	mov rdi, rax
	mov rax, qword [rbp-24]; printExpression variable size
	mov rsi, rax
	call GetChar
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	push rax; printExpression, leftPrinted, save left
	mov rbx, 83; printExpression, right char 'S'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov byte [rbp-27], al; VAR_DECL_ASSIGN else variable s
	movzx rax, byte [rbp-26]; printExpression, left identifier, rbp variable a
	movzx rbx, byte [rbp-27]; printExpression, right identifier, rbp variable s
	and al, bl
	mov rbx, rax; printExpression, nodeType=1
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable m
	and al, bl
	add rsp, 8
	jmp .exit
	add rsp, 8
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

global IsXMASNE
IsXMASNE:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 24
	mov qword [rbp-8], rdi
	mov qword [rbp-16], rsi
	mov qword [rbp-24], rdx
	sub rsp, 8
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, 1; printExpression, left int
	mov rbx, qword [rbp-16]; printExpression, right identifier, rbp variable length
	mul qword rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable index
	sub rax, rbx
	mov rdi, rax
	mov rax, qword [rbp-24]; printExpression variable size
	mov rsi, rax
	call GetChar
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	push rax; printExpression, leftPrinted, save left
	mov rbx, 77; printExpression, right char 'M'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov byte [rbp-25], al; VAR_DECL_ASSIGN else variable m
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, 2; printExpression, left int
	mov rbx, qword [rbp-16]; printExpression, right identifier, rbp variable length
	mul qword rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable index
	sub rax, rbx
	mov rdi, rax
	mov rax, qword [rbp-24]; printExpression variable size
	mov rsi, rax
	call GetChar
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	push rax; printExpression, leftPrinted, save left
	mov rbx, 65; printExpression, right char 'A'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov byte [rbp-26], al; VAR_DECL_ASSIGN else variable a
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, 3; printExpression, left int
	mov rbx, qword [rbp-16]; printExpression, right identifier, rbp variable length
	mul qword rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable index
	sub rax, rbx
	mov rdi, rax
	mov rax, qword [rbp-24]; printExpression variable size
	mov rsi, rax
	call GetChar
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	push rax; printExpression, leftPrinted, save left
	mov rbx, 83; printExpression, right char 'S'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov byte [rbp-27], al; VAR_DECL_ASSIGN else variable s
	movzx rax, byte [rbp-26]; printExpression, left identifier, rbp variable a
	movzx rbx, byte [rbp-27]; printExpression, right identifier, rbp variable s
	and al, bl
	mov rbx, rax; printExpression, nodeType=1
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable m
	and al, bl
	add rsp, 8
	jmp .exit
	add rsp, 8
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

global IsXMASSE
IsXMASSE:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 24
	mov qword [rbp-8], rdi
	mov qword [rbp-16], rsi
	mov qword [rbp-24], rdx
	sub rsp, 8
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, 1; printExpression, left int
	mov rbx, qword [rbp-16]; printExpression, right identifier, rbp variable length
	mul qword rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable index
	add rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 2; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov rdi, rax
	mov rax, qword [rbp-24]; printExpression variable size
	mov rsi, rax
	call GetChar
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	push rax; printExpression, leftPrinted, save left
	mov rbx, 77; printExpression, right char 'M'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov byte [rbp-25], al; VAR_DECL_ASSIGN else variable m
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, 2; printExpression, left int
	mov rbx, qword [rbp-16]; printExpression, right identifier, rbp variable length
	mul qword rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable index
	add rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 4; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov rdi, rax
	mov rax, qword [rbp-24]; printExpression variable size
	mov rsi, rax
	call GetChar
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	push rax; printExpression, leftPrinted, save left
	mov rbx, 65; printExpression, right char 'A'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov byte [rbp-26], al; VAR_DECL_ASSIGN else variable a
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, 3; printExpression, left int
	mov rbx, qword [rbp-16]; printExpression, right identifier, rbp variable length
	mul qword rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable index
	add rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 6; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov rdi, rax
	mov rax, qword [rbp-24]; printExpression variable size
	mov rsi, rax
	call GetChar
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	push rax; printExpression, leftPrinted, save left
	mov rbx, 83; printExpression, right char 'S'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov byte [rbp-27], al; VAR_DECL_ASSIGN else variable s
	movzx rax, byte [rbp-26]; printExpression, left identifier, rbp variable a
	movzx rbx, byte [rbp-27]; printExpression, right identifier, rbp variable s
	and al, bl
	mov rbx, rax; printExpression, nodeType=1
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable m
	and al, bl
	add rsp, 8
	jmp .exit
	add rsp, 8
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

global IsXMASSW
IsXMASSW:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 24
	mov qword [rbp-8], rdi
	mov qword [rbp-16], rsi
	mov qword [rbp-24], rdx
	sub rsp, 8
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, 1; printExpression, left int
	mov rbx, qword [rbp-16]; printExpression, right identifier, rbp variable length
	mul qword rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable index
	add rax, rbx
	mov rdi, rax
	mov rax, qword [rbp-24]; printExpression variable size
	mov rsi, rax
	call GetChar
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	push rax; printExpression, leftPrinted, save left
	mov rbx, 77; printExpression, right char 'M'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov byte [rbp-25], al; VAR_DECL_ASSIGN else variable m
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, 2; printExpression, left int
	mov rbx, qword [rbp-16]; printExpression, right identifier, rbp variable length
	mul qword rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable index
	add rax, rbx
	mov rdi, rax
	mov rax, qword [rbp-24]; printExpression variable size
	mov rsi, rax
	call GetChar
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	push rax; printExpression, leftPrinted, save left
	mov rbx, 65; printExpression, right char 'A'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov byte [rbp-26], al; VAR_DECL_ASSIGN else variable a
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, 3; printExpression, left int
	mov rbx, qword [rbp-16]; printExpression, right identifier, rbp variable length
	mul qword rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable index
	add rax, rbx
	mov rdi, rax
	mov rax, qword [rbp-24]; printExpression variable size
	mov rsi, rax
	call GetChar
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	push rax; printExpression, leftPrinted, save left
	mov rbx, 83; printExpression, right char 'S'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov byte [rbp-27], al; VAR_DECL_ASSIGN else variable s
	movzx rax, byte [rbp-26]; printExpression, left identifier, rbp variable a
	movzx rbx, byte [rbp-27]; printExpression, right identifier, rbp variable s
	and al, bl
	mov rbx, rax; printExpression, nodeType=1
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable m
	and al, bl
	add rsp, 8
	jmp .exit
	add rsp, 8
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
	mov qword [rbp-24], rax; VAR_DECL_ASSIGN else variable length
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
	jnz .if3
	jmp .end_if3
.if3:
	mov rax, qword [rbp-32]; printExpression variable i
	mov qword [rbp-24], rax; VAR_ASSIGNMENT else variable length
	jmp .not_label1
	jmp .end_if3
.end_if3:
	add rsp, 8
.skip_label1:
	mov rax, qword [rbp-32]; LOOP i
	inc rax
	mov qword [rbp-32], rax; LOOP i
	jmp .label1
.not_label1:
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-24]; variable length
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
	mov rax, 0
	mov qword [rbp-40], rax; LOOP i
.label2:
	mov rax, qword [rbp-8]; printExpression variable size
	cmp qword [rbp-40], rax; LOOP i
	jl .inside_label2
	jmp .not_label2
.inside_label2:
	sub rsp, 16
	mov rax, qword [rbp-40]; printExpression variable i
	cmp rax, 20000; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-41], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-41]; printExpression, left identifier, rbp variable byte
	mov rbx, 88; printExpression, right char 'X'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovne rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if4
	jmp .end_if4
.if4:
	jmp .skip_label2
	jmp .end_if4
.end_if4:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-40]; printExpression variable i
	mov rdi, rax
	mov rax, qword [rbp-8]; printExpression variable size
	mov rsi, rax
	call IsXMASBackwards
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov byte [rbp-42], al; VAR_DECL_ASSIGN else variable backward
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-40]; printExpression variable i
	mov rdi, rax
	mov rax, qword [rbp-8]; printExpression variable size
	mov rsi, rax
	call IsXMASForwards
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov byte [rbp-43], al; VAR_DECL_ASSIGN else variable forward
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-40]; printExpression variable i
	mov rdi, rax
	mov rax, qword [rbp-24]; printExpression variable length
	mov rsi, rax
	mov rax, qword [rbp-8]; printExpression variable size
	mov rdx, rax
	call IsXMASDown
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov byte [rbp-44], al; VAR_DECL_ASSIGN else variable down
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-40]; printExpression variable i
	mov rdi, rax
	mov rax, qword [rbp-24]; printExpression variable length
	mov rsi, rax
	mov rax, qword [rbp-8]; printExpression variable size
	mov rdx, rax
	call IsXMASUp
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov byte [rbp-45], al; VAR_DECL_ASSIGN else variable up
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-40]; printExpression variable i
	mov rdi, rax
	mov rax, qword [rbp-24]; printExpression variable length
	mov rsi, rax
	mov rax, qword [rbp-8]; printExpression variable size
	mov rdx, rax
	call IsXMASNW
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov byte [rbp-46], al; VAR_DECL_ASSIGN else variable nw
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-40]; printExpression variable i
	mov rdi, rax
	mov rax, qword [rbp-24]; printExpression variable length
	mov rsi, rax
	mov rax, qword [rbp-8]; printExpression variable size
	mov rdx, rax
	call IsXMASNE
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov byte [rbp-47], al; VAR_DECL_ASSIGN else variable ne
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-40]; printExpression variable i
	mov rdi, rax
	mov rax, qword [rbp-24]; printExpression variable length
	mov rsi, rax
	mov rax, qword [rbp-8]; printExpression variable size
	mov rdx, rax
	call IsXMASSE
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov byte [rbp-48], al; VAR_DECL_ASSIGN else variable se
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-40]; printExpression variable i
	mov rdi, rax
	mov rax, qword [rbp-24]; printExpression variable length
	mov rsi, rax
	mov rax, qword [rbp-8]; printExpression variable size
	mov rdx, rax
	call IsXMASSW
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov byte [rbp-49], al; VAR_DECL_ASSIGN else variable sw
	movzx rax, byte [rbp-42]; printExpression variable backward
	test rax, rax
	jnz .if5
	jmp .end_if5
.if5:
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable sum
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-16], rax; VAR_ASSIGNMENT else variable sum
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-40]; variable i
	call print_ui64
; =============== END FUNC CALL + VARIABLE ===============
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str0
	mov rdx, 19
	syscall
; =============== END FUNC CALL + STRING ===============
	jmp .end_if5
.end_if5:
	movzx rax, byte [rbp-43]; printExpression variable forward
	test rax, rax
	jnz .if6
	jmp .end_if6
.if6:
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable sum
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-16], rax; VAR_ASSIGNMENT else variable sum
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-40]; variable i
	call print_ui64
; =============== END FUNC CALL + VARIABLE ===============
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str1
	mov rdx, 18
	syscall
; =============== END FUNC CALL + STRING ===============
	jmp .end_if6
.end_if6:
	movzx rax, byte [rbp-44]; printExpression variable down
	test rax, rax
	jnz .if7
	jmp .end_if7
.if7:
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable sum
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-16], rax; VAR_ASSIGNMENT else variable sum
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-40]; variable i
	call print_ui64
; =============== END FUNC CALL + VARIABLE ===============
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str2
	mov rdx, 14
	syscall
; =============== END FUNC CALL + STRING ===============
	jmp .end_if7
.end_if7:
	movzx rax, byte [rbp-45]; printExpression variable up
	test rax, rax
	jnz .if8
	jmp .end_if8
.if8:
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable sum
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-16], rax; VAR_ASSIGNMENT else variable sum
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-40]; variable i
	call print_ui64
; =============== END FUNC CALL + VARIABLE ===============
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str3
	mov rdx, 12
	syscall
; =============== END FUNC CALL + STRING ===============
	jmp .end_if8
.end_if8:
	movzx rax, byte [rbp-46]; printExpression variable nw
	test rax, rax
	jnz .if9
	jmp .end_if9
.if9:
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable sum
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-16], rax; VAR_ASSIGNMENT else variable sum
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-40]; variable i
	call print_ui64
; =============== END FUNC CALL + VARIABLE ===============
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str4
	mov rdx, 12
	syscall
; =============== END FUNC CALL + STRING ===============
	jmp .end_if9
.end_if9:
	movzx rax, byte [rbp-47]; printExpression variable ne
	test rax, rax
	jnz .if10
	jmp .end_if10
.if10:
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable sum
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-16], rax; VAR_ASSIGNMENT else variable sum
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-40]; variable i
	call print_ui64
; =============== END FUNC CALL + VARIABLE ===============
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str5
	mov rdx, 12
	syscall
; =============== END FUNC CALL + STRING ===============
	jmp .end_if10
.end_if10:
	movzx rax, byte [rbp-48]; printExpression variable se
	test rax, rax
	jnz .if11
	jmp .end_if11
.if11:
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable sum
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-16], rax; VAR_ASSIGNMENT else variable sum
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-40]; variable i
	call print_ui64
; =============== END FUNC CALL + VARIABLE ===============
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str6
	mov rdx, 12
	syscall
; =============== END FUNC CALL + STRING ===============
	jmp .end_if11
.end_if11:
	movzx rax, byte [rbp-49]; printExpression variable sw
	test rax, rax
	jnz .if12
	jmp .end_if12
.if12:
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable sum
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-16], rax; VAR_ASSIGNMENT else variable sum
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-40]; variable i
	call print_ui64
; =============== END FUNC CALL + VARIABLE ===============
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str7
	mov rdx, 12
	syscall
; =============== END FUNC CALL + STRING ===============
	jmp .end_if12
.end_if12:
	add rsp, 16
.skip_label2:
	mov rax, qword [rbp-40]; LOOP i
	inc rax
	mov qword [rbp-40], rax; LOOP i
	jmp .label2
.not_label2:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str8
	mov rdx, 8
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
	mov qword [rbp-24], rax; VAR_DECL_ASSIGN else variable length
	mov rax, 0
	mov qword [rbp-32], rax; LOOP i
.label3:
	mov rax, qword [rbp-8]; printExpression variable size
	cmp qword [rbp-32], rax; LOOP i
	jl .inside_label3
	jmp .not_label3
.inside_label3:
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
	jnz .if13
	jmp .end_if13
.if13:
	mov rax, qword [rbp-32]; printExpression variable i
	mov qword [rbp-24], rax; VAR_ASSIGNMENT else variable length
	jmp .not_label3
	jmp .end_if13
.end_if13:
	add rsp, 8
.skip_label3:
	mov rax, qword [rbp-32]; LOOP i
	inc rax
	mov qword [rbp-32], rax; LOOP i
	jmp .label3
.not_label3:
	mov rax, 0
	mov qword [rbp-40], rax; LOOP i
.label4:
	mov rax, qword [rbp-8]; printExpression variable size
	cmp qword [rbp-40], rax; LOOP i
	jl .inside_label4
	jmp .not_label4
.inside_label4:
	sub rsp, 8
	mov rax, qword [rbp-40]; printExpression variable i
	cmp rax, 20000; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-41], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-41]; printExpression, left identifier, rbp variable byte
	mov rbx, 65; printExpression, right char 'A'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovne rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if14
	jmp .end_if14
.if14:
	jmp .skip_label4
	jmp .end_if14
.end_if14:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, 1; printExpression, left int
	mov rbx, qword [rbp-24]; printExpression, right identifier, rbp variable length
	mul qword rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-40]; printExpression, left identifier, rbp variable i
	sub rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 2; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	sub rax, rbx
	mov rdi, rax
	mov rax, qword [rbp-8]; printExpression variable size
	mov rsi, rax
	call GetChar
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov byte [rbp-42], al; VAR_DECL_ASSIGN else variable topLeft
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, 1; printExpression, left int
	mov rbx, qword [rbp-24]; printExpression, right identifier, rbp variable length
	mul qword rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-40]; printExpression, left identifier, rbp variable i
	sub rax, rbx
	mov rdi, rax
	mov rax, qword [rbp-8]; printExpression variable size
	mov rsi, rax
	call GetChar
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov byte [rbp-43], al; VAR_DECL_ASSIGN else variable topRight
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, 1; printExpression, left int
	mov rbx, qword [rbp-24]; printExpression, right identifier, rbp variable length
	mul qword rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-40]; printExpression, left identifier, rbp variable i
	add rax, rbx
	mov rdi, rax
	mov rax, qword [rbp-8]; printExpression variable size
	mov rsi, rax
	call GetChar
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov byte [rbp-44], al; VAR_DECL_ASSIGN else variable bottomLeft
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, 1; printExpression, left int
	mov rbx, qword [rbp-24]; printExpression, right identifier, rbp variable length
	mul qword rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-40]; printExpression, left identifier, rbp variable i
	add rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 2; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov rdi, rax
	mov rax, qword [rbp-8]; printExpression variable size
	mov rsi, rax
	call GetChar
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov byte [rbp-45], al; VAR_DECL_ASSIGN else variable bottomRight
	mov rax, 0
	mov byte [rbp-46], al; VAR_DECL_ASSIGN else variable firstSide
	mov rax, 0
	mov byte [rbp-47], al; VAR_DECL_ASSIGN else variable secondSide
	movzx rax, byte [rbp-42]; printExpression, left identifier, rbp variable topLeft
	mov rbx, 77; printExpression, right char 'M'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-45]; printExpression, left identifier, rbp variable bottomRight
	mov rbx, 83; printExpression, right char 'S'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and ax, bx
	test rax, rax
	jnz .if15
	jmp .else_if15
.if15:
	mov rax, 1
	mov byte [rbp-46], al; VAR_ASSIGNMENT else variable firstSide
	jmp .end_if15
.else_if15:
	movzx rax, byte [rbp-42]; printExpression, left identifier, rbp variable topLeft
	mov rbx, 83; printExpression, right char 'S'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-45]; printExpression, left identifier, rbp variable bottomRight
	mov rbx, 77; printExpression, right char 'M'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and ax, bx
	test rax, rax
	jnz .if16
	jmp .end_if16
.if16:
	mov rax, 1
	mov byte [rbp-46], al; VAR_ASSIGNMENT else variable firstSide
	jmp .end_if16
.end_if16:
.end_if15:
	movzx rax, byte [rbp-43]; printExpression, left identifier, rbp variable topRight
	mov rbx, 77; printExpression, right char 'M'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-44]; printExpression, left identifier, rbp variable bottomLeft
	mov rbx, 83; printExpression, right char 'S'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and ax, bx
	test rax, rax
	jnz .if17
	jmp .else_if17
.if17:
	mov rax, 1
	mov byte [rbp-47], al; VAR_ASSIGNMENT else variable secondSide
	jmp .end_if17
.else_if17:
	movzx rax, byte [rbp-43]; printExpression, left identifier, rbp variable topRight
	mov rbx, 83; printExpression, right char 'S'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-44]; printExpression, left identifier, rbp variable bottomLeft
	mov rbx, 77; printExpression, right char 'M'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and ax, bx
	test rax, rax
	jnz .if18
	jmp .end_if18
.if18:
	mov rax, 1
	mov byte [rbp-47], al; VAR_ASSIGNMENT else variable secondSide
	jmp .end_if18
.end_if18:
.end_if17:
	movzx rax, byte [rbp-46]; printExpression, left identifier, rbp variable firstSide
	movzx rbx, byte [rbp-47]; printExpression, right identifier, rbp variable secondSide
	and al, bl
	test rax, rax
	jnz .if19
	jmp .end_if19
.if19:
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable sum
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-16], rax; VAR_ASSIGNMENT else variable sum
	jmp .end_if19
.end_if19:
	add rsp, 8
.skip_label4:
	mov rax, qword [rbp-40]; LOOP i
	inc rax
	mov qword [rbp-40], rax; LOOP i
	jmp .label4
.not_label4:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str9
	mov rdx, 8
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
	jnz .if20
	jmp .end_if20
.if20:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str10
	mov rdx, 19
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, -1
	add rsp, 16
	jmp .exit
	jmp .end_if20
.end_if20:
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
	jnz .if21
	jmp .end_if21
.if21:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str11
	mov rdx, 24
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, -1
	add rsp, 16
	jmp .exit
	jmp .end_if21
.end_if21:
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
