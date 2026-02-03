	.file	1 "att_server.c"
	.section .mdebug.abi32
	.previous
	.gnu_attribute 4, 3
	.section	.text.att_handle_value_indication_notify_client,"ax",@progbits
	.align	2
	.set	mips16
	.ent	att_handle_value_indication_notify_client
	.type	att_handle_value_indication_notify_client, @function
att_handle_value_indication_notify_client:
	.frame	$sp,32,$31		# vars= 8, regs= 2/0, args= 16, gp= 0
	.mask	0x80010000,-4
	.fmask	0x00000000,0
	save	32,$16,$31
	move	$3,$sp
	li	$2,74
	move	$24,$5
	neg	$2,$2
	sb	$2,16($3)
	sb	$4,18($3)
	li	$2,5
	move	$16,$6
	addiu	$4,$sp,16
	move	$6,$24
	li	$5,3
	.set	noreorder
	.set	nomacro
	jal	bt_store_16
	sb	$2,17($3)
	.set	macro
	.set	reorder

	addiu	$4,$sp,16
	move	$6,$16
	.set	noreorder
	.set	nomacro
	jal	bt_store_16
	li	$5,5
	.set	macro
	.set	reorder

	lw	$2,$L2
	addiu	$6,$sp,16
	lw	$2,0($2)
	li	$4,4
	li	$5,0
	.set	noreorder
	.set	nomacro
	jalr	$2
	li	$7,7
	.set	macro
	.set	reorder

	restore	32,$16,$31
	j	$31
	.align	2
$L2:
	.word	att_client_packet_handler
	.end	att_handle_value_indication_notify_client
	.size	att_handle_value_indication_notify_client, .-att_handle_value_indication_notify_client
	.section	.text.att_handle_value_indication_timeout,"ax",@progbits
	.align	2
	.set	mips16
	.ent	att_handle_value_indication_timeout
	.type	att_handle_value_indication_timeout, @function
att_handle_value_indication_timeout:
	.frame	$sp,24,$31		# vars= 0, regs= 1/0, args= 16, gp= 0
	.mask	0x80000000,-4
	.fmask	0x00000000,0
	lw	$2,$L4
	save	24,$31
	lhu	$5,0($2)
	lw	$2,$L5
	li	$4,145
	.set	noreorder
	.set	nomacro
	jal	att_handle_value_indication_notify_client
	lhu	$6,0($2)
	.set	macro
	.set	reorder

	restore	24,$31
	j	$31
	.align	2
$L4:
	.word	att_connection
$L5:
	.word	att_handle_value_indication_handle
	.end	att_handle_value_indication_timeout
	.size	att_handle_value_indication_timeout, .-att_handle_value_indication_timeout
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align	2
$LC3:
	.ascii	"ATT Signed Write!\012\000"
	.align	2
$LC4:
	.ascii	"ATT Signed Write, sm_cmac engine not ready. Abort\012\000"
	.align	2
$LC5:
	.ascii	"ATT Signed Write, request to short. Abort.\012\000"
	.align	2
$LC6:
	.ascii	"ATT Signed Write, CSRK not available\012\000"
	.align	2
$LC7:
	.ascii	"ATT Signed Write, DB counter %u, packet counter %u\012\000"
	.align	2
$LC8:
	.ascii	"ATT Signed Write, db reports higher counter, abort\012\000"
	.align	2
$LC9:
	.ascii	"Orig Signature: \000"
	.section	.text.att_run,"ax",@progbits
	.align	2
	.set	mips16
	.ent	att_run
	.type	att_run, @function
att_run:
	.frame	$sp,56,$31		# vars= 24, regs= 3/0, args= 16, gp= 0
	.mask	0x80030000,-4
	.fmask	0x00000000,0
	lw	$3,$L19
	save	56,$16,$17,$31
	lw	$2,0($3)
	cmpi	$2,1
	bteqz	$L8
	cmpi	$2,3
	bteqz	$L9
	b	$L6
$L8:
	lw	$5,$L20
	li	$2,210
	lbu	$17,0($5)
	xor	$17,$2
	bnez	$17,$L9
	lw	$4,$L21
	jal	xprintf
	jal	sm_cmac_ready
	move	$16,$2
	bnez	$2,$L10
	lw	$4,$L22
	jal	xprintf
	lw	$3,$L19
	sw	$16,0($3)
	b	$L6
$L10:
	lw	$5,$L23
	lhu	$2,0($5)
	sltu	$2,15
	bteqz	$L11
	lw	$4,$L24
	jal	xprintf
	lw	$2,$L19
	sw	$17,0($2)
	b	$L6
$L11:
	lw	$3,$L25
	lw	$3,0($3)
	sw	$3,32($sp)
	bnez	$3,$L6
	lw	$3,$L26
	lw	$4,0($3)
	slt	$4,0
	bteqz	$L12
	lw	$4,$L27
	jal	xprintf
	lw	$5,32($sp)
	lw	$3,$L19
	sw	$5,0($3)
	b	$L6
$L12:
	lw	$5,$L20
	addu	$2,$5,$2
	lbu	$5,-10($2)
	lbu	$17,-11($2)
	sll	$5,$5,8
	sll	$5,$5,8
	sll	$17,$17,8
	or	$17,$5
	lbu	$5,-12($2)
	lbu	$2,-9($2)
	or	$17,$5
	sll	$2,$2,24
	or	$17,$2
	.set	noreorder
	.set	nomacro
	jal	central_device_db_counter_get
	sw	$3,36($sp)
	.set	macro
	.set	reorder

	move	$16,$2
	lw	$4,$L28
	move	$5,$2
	.set	noreorder
	.set	nomacro
	jal	xprintf
	move	$6,$17
	.set	macro
	.set	reorder

	sltu	$17,$16
	lw	$3,36($sp)
	bteqz	$L13
	lw	$4,$L29
	jal	xprintf
	lw	$3,32($sp)
	lw	$2,$L19
	sw	$3,0($2)
	b	$L6
$L13:
	lw	$4,0($3)
	.set	noreorder
	.set	nomacro
	jal	central_device_db_csrk
	addiu	$5,$sp,16
	.set	macro
	.set	reorder

	lw	$5,$L19
	li	$2,2
	lw	$4,$L30
	.set	noreorder
	.set	nomacro
	jal	xprintf
	sw	$2,0($5)
	.set	macro
	.set	reorder

	lw	$2,$L23
	lw	$3,$L20
	lhu	$4,0($2)
	li	$5,8
	addiu	$4,-8
	.set	noreorder
	.set	nomacro
	jal	hexdump
	addu	$4,$3,$4
	.set	macro
	.set	reorder

	lw	$2,$L23
	addiu	$4,$sp,16
	lhu	$5,0($2)
	lw	$6,$L20
	addiu	$5,-8
	lw	$7,$L31
	.set	noreorder
	.set	nomacro
	jal	sm_cmac_start
	zeh	$5
	.set	macro
	.set	reorder

	b	$L6
$L9:
	jal	l2cap_can_send_connectionless_packet_now
	beqz	$2,$L6
	jal	l2cap_reserve_packet_buffer
	jal	l2cap_get_outgoing_buffer
	move	$16,$2
	lw	$2,$L23
	lw	$4,$L32
	lhu	$6,0($2)
	lw	$5,$L20
	.set	noreorder
	.set	nomacro
	jal	att_handle_request
	move	$7,$16
	.set	macro
	.set	reorder

	sltu	$2,4
	move	$17,$2
	btnez	$L14
	lbu	$2,0($16)
	cmpi	$2,1
	btnez	$L14
	lbu	$2,4($16)
	cmpi	$2,8
	btnez	$L14
	lw	$2,$L32
	lbu	$2,5($2)
	beqz	$2,$L14
	lw	$16,$L33
	lw	$5,$L34
	.set	noreorder
	.set	nomacro
	jal	sm_authorization_state
	lbu	$4,0($16)
	.set	macro
	.set	reorder

	beqz	$2,$L15
	cmpi	$2,1
	bteqz	$L18
	b	$L14
$L15:
	jal	l2cap_release_packet_buffer
	lw	$5,$L34
	.set	noreorder
	.set	nomacro
	jal	sm_request_authorization
	lbu	$4,0($16)
	.set	macro
	.set	reorder

	b	$L6
$L14:
	lw	$2,$L19
	li	$3,0
	sw	$3,0($2)
	bnez	$17,$L17
$L18:
	jal	l2cap_release_packet_buffer
	b	$L6
$L17:
	lw	$2,$L32
	li	$5,4
	lhu	$4,0($2)
	.set	noreorder
	.set	nomacro
	jal	l2cap_send_prepared_connectionless
	move	$6,$17
	.set	macro
	.set	reorder

$L6:
	restore	56,$16,$17,$31
	j	$31
	.align	2
$L19:
	.word	att_server_state
$L20:
	.word	att_request_buffer
$L21:
	.word	$LC3
$L22:
	.word	$LC4
$L23:
	.word	att_request_size
$L24:
	.word	$LC5
$L25:
	.word	att_ir_lookup_active
$L26:
	.word	att_ir_central_device_db_index
$L27:
	.word	$LC6
$L28:
	.word	$LC7
$L29:
	.word	$LC8
$L30:
	.word	$LC9
$L31:
	.word	att_signed_write_handle_cmac_result
$L32:
	.word	att_connection
$L33:
	.word	att_client_addr_type
$L34:
	.word	att_client_address
	.end	att_run
	.size	att_run, .-att_run
	.section	.rodata.str1.4
	.align	2
$LC26:
	.ascii	"SM_IDENTITY_RESOLVING_STARTED\012\000"
	.align	2
$LC27:
	.ascii	"SM_IDENTITY_RESOLVING_SUCCEEDED id %u\012\000"
	.align	2
$LC28:
	.ascii	"SM_IDENTITY_RESOLVING_FAILED\012\000"
	.section	.text.att_event_packet_handler,"ax",@progbits
	.align	2
	.set	mips16
	.ent	att_event_packet_handler
	.type	att_event_packet_handler, @function
att_event_packet_handler:
	.frame	$sp,48,$31		# vars= 16, regs= 3/0, args= 16, gp= 0
	.mask	0x80030000,-4
	.fmask	0x00000000,0
	save	48,$16,$17,$31
	zeb	$4
	zeh	$5
	zeh	$7
	cmpi	$4,4
	move	$17,$6
	sw	$4,16($sp)
	sw	$5,20($sp)
	sw	$7,24($sp)
	btnez	$L36
	lbu	$2,0($6)
	cmpi	$2,84
	bteqz	$L50
	sltu	$2,85
	bteqz	$L46
	cmpi	$2,8
	bteqz	$L39
	cmpi	$2,62
	bteqz	$L40
	li	$16,5
	xor	$16,$2
	beqz	$16,$L38
	b	$L36
$L46:
	li	$16,215
	xor	$16,$2
	beqz	$16,$L43
	sltu	$2,216
	bteqz	$L47
	cmpi	$2,214
	bteqz	$L42
	b	$L36
$L47:
	cmpi	$2,216
	bteqz	$L44
	cmpi	$2,218
	bteqz	$L45
	b	$L36
$L40:
	lbu	$3,2($6)
	li	$2,1
	xor	$3,$2
	bnez	$3,$L36
	lbu	$4,7($6)
	lw	$2,$L51
	addiu	$5,$6,7
	sb	$4,0($2)
	addiu	$5,1
	lw	$4,$L52
	.set	noreorder
	.set	nomacro
	jal	bt_flip_addr
	sw	$3,28($sp)
	.set	macro
	.set	reorder

	lbu	$2,5($17)
	lbu	$4,4($17)
	lw	$16,$L53
	sll	$2,$2,8
	or	$2,$4
	.set	noreorder
	.set	nomacro
	jal	l2cap_max_mtu
	sh	$2,0($16)
	.set	macro
	.set	reorder

	lw	$3,28($sp)
	sh	$2,2($16)
	sb	$3,4($16)
	sb	$3,5($16)
	sb	$3,6($16)
	b	$L36
$L39:
	lw	$3,$L53
	lbu	$2,4($6)
	lbu	$5,3($6)
	lhu	$4,0($3)
	sll	$2,$2,8
	or	$2,$5
	xor	$2,$4
	bnez	$2,$L36
	lw	$16,$L51
	lw	$5,$L52
	lbu	$4,0($16)
	.set	noreorder
	.set	nomacro
	jal	sm_encryption_key_size
	sw	$3,28($sp)
	.set	macro
	.set	reorder

	lw	$3,28($sp)
	lbu	$4,0($16)
	lw	$5,$L52
	sb	$2,4($3)
	.set	noreorder
	.set	nomacro
	jal	sm_authenticated
	sw	$3,28($sp)
	.set	macro
	.set	reorder

	lw	$3,28($sp)
	sb	$2,5($3)
	b	$L36
$L38:
	lw	$4,$L53
	jal	att_clear_transaction_queue
	lw	$2,$L53
	sh	$16,0($2)
	lw	$2,$L54
	sw	$16,0($2)
	lw	$2,$L55
	sw	$16,0($2)
	b	$L36
$L42:
	lw	$4,$L56
	jal	xprintf
	lw	$2,$L57
	li	$3,1
	sw	$3,0($2)
	b	$L36
$L44:
	lw	$2,$L57
	move	$3,$24
	sw	$3,0($2)
	lhu	$5,12($6)
	lw	$2,$L58
	lw	$4,$L59
	.set	noreorder
	.set	nomacro
	jal	xprintf
	sw	$5,0($2)
	.set	macro
	.set	reorder

	b	$L50
$L43:
	lw	$4,$L60
	jal	xprintf
	lw	$2,$L57
	li	$3,1
	sw	$16,0($2)
	lw	$2,$L58
	neg	$3,$3
	sw	$3,0($2)
	b	$L50
$L45:
	lw	$2,$L51
	lbu	$3,1($6)
	lbu	$2,0($2)
	cmp	$3,$2
	btnez	$L36
	addiu	$4,$6,2
	lw	$5,$L52
	.set	noreorder
	.set	nomacro
	jal	memcmp
	li	$6,6
	.set	macro
	.set	reorder

	bnez	$2,$L36
	lbu	$3,14($17)
	lw	$2,$L53
	sb	$3,6($2)
$L50:
	jal	att_run
$L36:
	lw	$2,$L61
	lw	$2,0($2)
	beqz	$2,$L35
	lw	$4,16($sp)
	lw	$5,20($sp)
	lw	$7,24($sp)
	.set	noreorder
	.set	nomacro
	jalr	$2
	move	$6,$17
	.set	macro
	.set	reorder

$L35:
	restore	48,$16,$17,$31
	j	$31
	.align	2
$L51:
	.word	att_client_addr_type
$L52:
	.word	att_client_address
$L53:
	.word	att_connection
$L54:
	.word	att_handle_value_indication_handle
$L55:
	.word	att_server_state
$L56:
	.word	$LC26
$L57:
	.word	att_ir_lookup_active
$L58:
	.word	att_ir_central_device_db_index
$L59:
	.word	$LC27
$L60:
	.word	$LC28
$L61:
	.word	att_client_packet_handler
	.end	att_event_packet_handler
	.size	att_event_packet_handler, .-att_event_packet_handler
	.section	.text.att_packet_handler,"ax",@progbits
	.align	2
	.set	mips16
	.ent	att_packet_handler
	.type	att_packet_handler, @function
att_packet_handler:
	.frame	$sp,32,$31		# vars= 0, regs= 3/0, args= 16, gp= 0
	.mask	0x80030000,-4
	.fmask	0x00000000,0
	zeb	$4
	cmpi	$4,8
	save	32,$16,$17,$31
	move	$5,$6
	zeh	$7
	btnez	$L62
	lbu	$17,0($6)
	li	$2,30
	xor	$17,$2
	bnez	$17,$L64
	lw	$16,$L65
	lw	$2,0($16)
	beqz	$2,$L64
	lw	$4,$L66
	jal	run_loop_remove_timer
	lw	$2,$L67
	lhu	$6,0($16)
	lhu	$5,0($2)
	li	$4,0
	.set	noreorder
	.set	nomacro
	jal	att_handle_value_indication_notify_client
	sw	$17,0($16)
	.set	macro
	.set	reorder

	b	$L62
$L64:
	sltu	$7,29
	bteqz	$L62
	lw	$2,$L68
	lw	$3,0($2)
	bnez	$3,$L62
	li	$3,1
	sw	$3,0($2)
	lw	$2,$L69
	lw	$4,$L70
	sh	$7,0($2)
	.set	noreorder
	.set	nomacro
	jal	memcpy
	move	$6,$7
	.set	macro
	.set	reorder

	jal	att_run
$L62:
	restore	32,$16,$17,$31
	j	$31
	.align	2
$L65:
	.word	att_handle_value_indication_handle
$L66:
	.word	att_handle_value_indication_timer
$L67:
	.word	att_connection
$L68:
	.word	att_server_state
$L69:
	.word	att_request_size
$L70:
	.word	att_request_buffer
	.end	att_packet_handler
	.size	att_packet_handler, .-att_packet_handler
	.section	.rodata.str1.4
	.align	2
$LC46:
	.ascii	"ATT Signed Write, invalid signature\012\000"
	.section	.text.att_signed_write_handle_cmac_result,"ax",@progbits
	.align	2
	.set	mips16
	.ent	att_signed_write_handle_cmac_result
	.type	att_signed_write_handle_cmac_result, @function
att_signed_write_handle_cmac_result:
	.frame	$sp,40,$31		# vars= 8, regs= 3/0, args= 16, gp= 0
	.mask	0x80030000,-4
	.fmask	0x00000000,0
	lw	$3,$L74
	save	40,$16,$17,$31
	lw	$2,0($3)
	cmpi	$2,2
	move	$3,$24
	sw	$3,16($sp)
	bnez	$3,$L71
	lw	$2,$L75
	lw	$16,$L76
	lhu	$17,0($2)
	li	$6,8
	addiu	$5,$17,-8
	.set	noreorder
	.set	nomacro
	jal	memcmp
	addu	$5,$16,$5
	.set	macro
	.set	reorder

	beqz	$2,$L73
	lw	$4,$L77
	jal	xprintf
	lw	$3,16($sp)
	lw	$2,$L74
	sw	$3,0($2)
	b	$L71
$L73:
	addu	$16,$16,$17
	lbu	$2,-10($16)
	lbu	$5,-11($16)
	sll	$2,$2,8
	sll	$2,$2,8
	sll	$5,$5,8
	or	$5,$2
	lbu	$2,-12($16)
	or	$5,$2
	lbu	$2,-9($16)
	sll	$2,$2,24
	or	$5,$2
	lw	$2,$L78
	addiu	$5,1
	.set	noreorder
	.set	nomacro
	jal	central_device_db_counter_set
	lw	$4,0($2)
	.set	macro
	.set	reorder

	lw	$3,$L74
	li	$2,3
	.set	noreorder
	.set	nomacro
	jal	att_run
	sw	$2,0($3)
	.set	macro
	.set	reorder

$L71:
	restore	40,$16,$17,$31
	j	$31
	.align	2
$L74:
	.word	att_server_state
$L75:
	.word	att_request_size
$L76:
	.word	att_request_buffer
$L77:
	.word	$LC46
$L78:
	.word	att_ir_central_device_db_index
	.end	att_signed_write_handle_cmac_result
	.size	att_signed_write_handle_cmac_result, .-att_signed_write_handle_cmac_result
	.section	.text.att_server_init,"ax",@progbits
	.align	2
	.globl	att_server_init
	.set	mips16
	.ent	att_server_init
	.type	att_server_init, @function
att_server_init:
	.frame	$sp,40,$31		# vars= 8, regs= 3/0, args= 16, gp= 0
	.mask	0x80030000,-4
	.fmask	0x00000000,0
	save	40,$16,$17,$31
	move	$2,$4
	lw	$4,$L80
	move	$17,$5
	move	$16,$6
	.set	noreorder
	.set	nomacro
	jal	sm_register_packet_handler
	sw	$2,16($sp)
	.set	macro
	.set	reorder

	lw	$4,$L81
	jal	att_dispatch_register_server
	lw	$2,16($sp)
	lw	$3,$L82
	li	$4,0
	sw	$4,0($3)
	.set	noreorder
	.set	nomacro
	jal	att_set_db
	move	$4,$2
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	jal	att_set_read_callback
	move	$4,$17
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	jal	att_set_write_callback
	move	$4,$16
	.set	macro
	.set	reorder

	restore	40,$16,$17,$31
	j	$31
	.align	2
$L80:
	.word	att_event_packet_handler
$L81:
	.word	att_packet_handler
$L82:
	.word	att_server_state
	.end	att_server_init
	.size	att_server_init, .-att_server_init
	.section	.text.att_server_register_packet_handler,"ax",@progbits
	.align	2
	.globl	att_server_register_packet_handler
	.set	mips16
	.ent	att_server_register_packet_handler
	.type	att_server_register_packet_handler, @function
att_server_register_packet_handler:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	lw	$2,$L84
	.set	noreorder
	.set	nomacro
	j	$31
	sw	$4,0($2)
	.set	macro
	.set	reorder

	.align	2
$L84:
	.word	att_client_packet_handler
	.end	att_server_register_packet_handler
	.size	att_server_register_packet_handler, .-att_server_register_packet_handler
	.section	.text.att_server_can_send,"ax",@progbits
	.align	2
	.globl	att_server_can_send
	.set	mips16
	.ent	att_server_can_send
	.type	att_server_can_send, @function
att_server_can_send:
	.frame	$sp,24,$31		# vars= 0, regs= 1/0, args= 16, gp= 0
	.mask	0x80000000,-4
	.fmask	0x00000000,0
	lw	$2,$L88
	save	24,$31
	lhu	$3,0($2)
	li	$2,0
	beqz	$3,$L86
	jal	l2cap_can_send_connectionless_packet_now
$L86:
	restore	24,$31
	j	$31
	.align	2
$L88:
	.word	att_connection
	.end	att_server_can_send
	.size	att_server_can_send, .-att_server_can_send
	.section	.text.att_server_notify,"ax",@progbits
	.align	2
	.globl	att_server_notify
	.set	mips16
	.ent	att_server_notify
	.type	att_server_notify, @function
att_server_notify:
	.frame	$sp,40,$31		# vars= 0, regs= 3/0, args= 24, gp= 0
	.mask	0x80030000,-4
	.fmask	0x00000000,0
	save	$4-$5,40,$16,$17,$31
	move	$16,$4
	.set	noreorder
	.set	nomacro
	jal	l2cap_can_send_connectionless_packet_now
	move	$17,$6
	.set	macro
	.set	reorder

	zeh	$16
	zeh	$17
	li	$3,87
	beqz	$2,$L90
	jal	l2cap_reserve_packet_buffer
	jal	l2cap_get_outgoing_buffer
	lw	$6,44($sp)
	lw	$4,$L92
	move	$5,$16
	move	$7,$17
	.set	noreorder
	.set	nomacro
	jal	att_prepare_handle_value_notification
	sw	$2,16($sp)
	.set	macro
	.set	reorder

	lw	$3,$L92
	li	$5,4
	lhu	$4,0($3)
	.set	noreorder
	.set	nomacro
	jal	l2cap_send_prepared_connectionless
	move	$6,$2
	.set	macro
	.set	reorder

	move	$3,$2
$L90:
	restore	40,$16,$17,$31
	.set	noreorder
	.set	nomacro
	j	$31
	move	$2,$3
	.set	macro
	.set	reorder

	.align	2
$L92:
	.word	att_connection
	.end	att_server_notify
	.size	att_server_notify, .-att_server_notify
	.section	.text.att_server_indicate,"ax",@progbits
	.align	2
	.globl	att_server_indicate
	.set	mips16
	.ent	att_server_indicate
	.type	att_server_indicate, @function
att_server_indicate:
	.frame	$sp,48,$31		# vars= 8, regs= 3/0, args= 24, gp= 0
	.mask	0x80030000,-4
	.fmask	0x00000000,0
	save	$4-$5,48,$16,$17,$31
	lw	$16,$L97
	move	$17,$4
	lw	$2,0($16)
	zeh	$6
	zeh	$17
	sw	$6,24($sp)
	li	$3,144
	bnez	$2,$L94
	jal	l2cap_can_send_connectionless_packet_now
	li	$3,87
	beqz	$2,$L94
	lw	$4,$L98
	lw	$5,$L99
	.set	noreorder
	.set	nomacro
	jal	run_loop_set_timer_handler
	sw	$17,0($16)
	.set	macro
	.set	reorder

	li	$5,30000
	lw	$4,$L98
	jal	run_loop_set_timer
	lw	$4,$L98
	jal	run_loop_add_timer
	jal	l2cap_reserve_packet_buffer
	jal	l2cap_get_outgoing_buffer
	lw	$6,52($sp)
	lw	$7,24($sp)
	lw	$4,$L100
	move	$5,$17
	.set	noreorder
	.set	nomacro
	jal	att_prepare_handle_value_indication
	sw	$2,16($sp)
	.set	macro
	.set	reorder

	lw	$3,$L100
	li	$5,4
	lhu	$4,0($3)
	.set	noreorder
	.set	nomacro
	jal	l2cap_send_prepared_connectionless
	move	$6,$2
	.set	macro
	.set	reorder

	li	$3,0
$L94:
	restore	48,$16,$17,$31
	.set	noreorder
	.set	nomacro
	j	$31
	move	$2,$3
	.set	macro
	.set	reorder

	.align	2
$L97:
	.word	att_handle_value_indication_handle
$L98:
	.word	att_handle_value_indication_timer
$L99:
	.word	att_handle_value_indication_timeout
$L100:
	.word	att_connection
	.end	att_server_indicate
	.size	att_server_indicate, .-att_server_indicate
	.section	.bss.att_server_state,"aw",@nobits
	.align	2
	.type	att_server_state, @object
	.size	att_server_state, 4
att_server_state:
	.space	4
	.section	.bss.att_handle_value_indication_handle,"aw",@nobits
	.align	2
	.type	att_handle_value_indication_handle, @object
	.size	att_handle_value_indication_handle, 4
att_handle_value_indication_handle:
	.space	4
	.section	.bss.att_request_size,"aw",@nobits
	.align	1
	.type	att_request_size, @object
	.size	att_request_size, 2
att_request_size:
	.space	2
	.section	.bss.att_request_buffer,"aw",@nobits
	.align	2
	.type	att_request_buffer, @object
	.size	att_request_buffer, 28
att_request_buffer:
	.space	28
	.section	.bss.att_handle_value_indication_timer,"aw",@nobits
	.align	2
	.type	att_handle_value_indication_timer, @object
	.size	att_handle_value_indication_timer, 12
att_handle_value_indication_timer:
	.space	12
	.section	.bss.att_connection,"aw",@nobits
	.align	2
	.type	att_connection, @object
	.size	att_connection, 8
att_connection:
	.space	8
	.section	.bss.att_client_packet_handler,"aw",@nobits
	.align	2
	.type	att_client_packet_handler, @object
	.size	att_client_packet_handler, 4
att_client_packet_handler:
	.space	4
	.section	.bss.att_ir_lookup_active,"aw",@nobits
	.align	2
	.type	att_ir_lookup_active, @object
	.size	att_ir_lookup_active, 4
att_ir_lookup_active:
	.space	4
	.section	.data.att_ir_central_device_db_index,"aw",@progbits
	.align	2
	.type	att_ir_central_device_db_index, @object
	.size	att_ir_central_device_db_index, 4
att_ir_central_device_db_index:
	.word	-1
	.section	.bss.att_client_addr_type,"aw",@nobits
	.type	att_client_addr_type, @object
	.size	att_client_addr_type, 1
att_client_addr_type:
	.space	1
	.section	.bss.att_client_address,"aw",@nobits
	.align	2
	.type	att_client_address, @object
	.size	att_client_address, 6
att_client_address:
	.space	6
	.ident	"GCC: (Pinguino C compiler for PIC32) 4.6.2"
