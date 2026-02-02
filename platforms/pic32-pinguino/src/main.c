/*
 * Copyright (C) 2011-2013 by Matthias Ringwald
 * Copyright (C) 2014 by Hiroki Mori
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the copyright holders nor the names of
 *    contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 * 4. This software may not be used in a commercial product
 *    without an explicit license granted by the copyright holder. 
 *
 * THIS SOFTWARE IS PROVIDED BY MATTHIAS RINGWALD AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL MATTHIAS
 * RINGWALD OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
 * THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 */

#include "GenericTypeDefs.h"
#include "HardwareProfile.h"
#include "USB/usb.h"

#include "btstack-config.h"
#include "debug.h"

#include "hci.h"

extern void (*xfunc_out)(unsigned char);
extern void setup(void);


DEBUG_PutChar(char c) {
#ifdef USBHOSTBT_DEBUG
	xprintf("%c",c);
#endif
}
DEBUG_PutString(char *ptr) {
#ifdef USBHOSTBT_DEBUG
	xprintf("%s", ptr);
#endif
}
DEBUG_PutHexUINT8(char n) {
#ifdef USBHOSTBT_DEBUG
	xprintf("%02x", n);
#endif
}

/*PIC32 USB HOST APPLICATION USB EVENT HANDLER*/
BOOL USB_ApplicationEventHandler ( BYTE address, USB_EVENT event, void *data, DWORD size )
{
    log_info("USB_ApplicationEventHandler %d %d", address, event);
	switch (event)
	{
        case EVENT_VBUS_REQUEST_POWER:
            return TRUE;
	}
	return FALSE;
}

/*PIC32 USB HOST Scans the USB Port*/
void MyUSBScan()
{
	USBHostBTstackRead_Event();
	USBHostBTStackRead_ACL();
	DelayMs(10);
}

startbt()
{
	btstack_main();

    // turn on!
	hci_power_control(HCI_POWER_ON);
}

int ledcount = 0;

setled()
{
	ledcount = 0x200;
	PORTSetBits(IOPORT_B, BIT_15);
}

static int pic32_process_ds(struct data_source *ds) {	
	//Maintain the USB status
	USBHostTasks();
	//Maintain the application
	MyUSBScan();
	
	if(ledcount != 0) {
		--ledcount;
		if(ledcount == 0) {
			PORTClearBits(IOPORT_B, BIT_15);
		}
	}
	
	return 0;
}



int main(void)
{
	int  value;

	static data_source_t pic32_data;

	value = SYSTEMConfigWaitStatesAndPB( GetSystemClock() );
	// Enable the cache for the best performance
	CheKseg0CacheOn();
	INTEnableSystemMultiVectoredInt();
	value = OSCCON;
	while (!(value & 0x00000020))
	{
		value = OSCCON;    // Wait for PLL lock to stabilize
	}
	
    // Set LED Pins to Outputs
    PORTSetPinsDigitalOut(IOPORT_B, BIT_15);

	PORTClearBits(IOPORT_B, BIT_15);

// for Debug
	
    mInitAllSwitches();
	
    SIOInit();
	
	xfunc_out=UART1PutChar;
	
    log_info("BTstack ANCS Client starting up...");
	
	USBHostInit(0);
	
    /// GET STARTED with BTstack ///
    btstack_memory_init();
    run_loop_init(RUN_LOOP_EMBEDDED);
	
    hci_transport_t    * transport = hci_transport_pic32_instance();
    hci_uart_config_t  * config    = NULL;
    bt_control_t       * control   = NULL;
    remote_device_db_t * remote_db = (remote_device_db_t *) &remote_device_db_memory;
    hci_init(transport, config, control, remote_db);

	pic32_data.process = pic32_process_ds;
	run_loop_add_data_source(&pic32_data);
	
    // go!
    run_loop_execute(); 
	
    // happy compiler!
    return 0;
}
