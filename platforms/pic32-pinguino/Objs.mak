#
#	Object List
#

OBJS = \
	main.o \
	xprintf.o \
	uart1.o \
	crt.o \
	sbrk.o \
	led.o \
	hal_cpu.o \
	config.o \
	usb_config.o \
	Microchip/USB/usb_host.o \
	TimeDelay.o \
	${BTSTACK_ROOT}/src/btstack_memory.o \
	${BTSTACK_ROOT}/src/linked_list.o \
	${BTSTACK_ROOT}/src/memory_pool.o \
	${BTSTACK_ROOT}/src/run_loop.o \
	${BTSTACK_ROOT}/src/run_loop_embedded.o \
	${BTSTACK_ROOT}/src/sdp_util.o \
	hci_transport_pic32.o \
	\
	${BTSTACK_ROOT}/src/hci.o \
	${BTSTACK_ROOT}/src/hci_cmds.o \
	${BTSTACK_ROOT}/src/hci_dump.o \
	${BTSTACK_ROOT}/src/utils.o \
	${BTSTACK_ROOT}/src/remote_device_db_memory.o \
	${BTSTACK_ROOT}/ble/att.o \
	${BTSTACK_ROOT}/ble/att_dispatch.o \
	${BTSTACK_ROOT}/ble/att_server.o \
	${BTSTACK_ROOT}/ble/l2cap_le.o \
	${BTSTACK_ROOT}/ble/sm.o \
	${BTSTACK_ROOT}/ble/gatt_client.o \
	${BTSTACK_ROOT}/ble/le_device_db_memory.o \
	${BTSTACK_ROOT}/ble/ancs_client_lib.o \
	${BTSTACK_ROOT}/example/embedded/ancs_client.o


