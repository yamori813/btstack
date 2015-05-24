/*
 * Copyright (C) 2009-2012 by Matthias Ringwald
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
 * 4. Any redistribution, use, or modification is done solely for
 *    personal benefit and not for any commercial purpose or for
 *    monetary gain.
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
 * Please inquire about commercial licensing options at btstack@ringwald.ch
 *
 */

/*
 *  hci_transport_pic32.c
 *
 *  HCI Transport API implementation for PIC32
 *
 *  Created by Hiroki Mori on 7/18/14.
 */

// Interface Number - Alternate Setting - suggested Endpoint Address - Endpoint Type - Suggested Max Packet Size 
// HCI Commands 0 0 0x00 Control 8/16/32/64 
// HCI Events   0 0 0x81 Interrupt (IN) 16 
// ACL Data     0 0 0x82 Bulk (IN) 32/64 
// ACL Data     0 0 0x02 Bulk (OUT) 32/64 

#include "USB/usb.h"
#include "usb_host.h"

#include "btstack-config.h"

#include "debug.h"
#include "hci.h"
#include "hci_transport.h"
#include "hci_dump.h"

static void dummy_handler(uint8_t packet_type, uint8_t *packet, uint16_t size); 

static void (*packet_handler)(uint8_t packet_type, uint8_t *packet, uint16_t size) = dummy_handler;

BYTE deviceAddress;
BYTE clientDriverID;

BYTE startEvent = 0;
BYTE startACL = 0;

BYTE eventData[32];
BYTE aclData[128];

// Called by Microchip UsbHost stack

BOOL USBHostBTstackInit ( BYTE address, DWORD flags, BYTE driverID )
{
    log_info("USBHostBTstackInit %d %d", address, flags);
	deviceAddress = address;
	clientDriverID = driverID;

	startbt();

    return TRUE;
}

BOOL USBHostBTstackEventHandler ( BYTE address, USB_EVENT event, void *data, DWORD size )
{
    log_info("USBHostBTstackEventHandler\n");
	BOOL res = FALSE;

	switch (event)
    {
        case EVENT_DETACH:
			break;

        case EVENT_TRANSFER:
			if ( (data != NULL) && (size == sizeof(HOST_TRANSFER_DATA)) )
            {
				BYTE endAddr = ((HOST_TRANSFER_DATA *)data)->bEndpointAddress;
				BYTE *dataPtr = ((HOST_TRANSFER_DATA *)data)->pUserData;
				DWORD dataCount = ((HOST_TRANSFER_DATA *)data)->dataCount;

				if ( endAddr == (USB_IN_EP|USB_EP1) ) 
				{
					if(dataCount != 0)
						packet_handler(HCI_EVENT_PACKET, eventData, dataCount);
					startEvent = 0;
					res = TRUE;
				}
				else if ( endAddr == (USB_IN_EP|USB_EP2) )
				{
					if(dataCount != 0)
						packet_handler(HCI_ACL_DATA_PACKET, aclData, dataCount);
					startACL = 0;
					res =TRUE;
				}
				else if ( endAddr == (USB_OUT_EP|USB_EP2) )
				{
					uint8_t event[] = { DAEMON_EVENT_HCI_PACKET_SENT, 0};
					packet_handler(HCI_EVENT_PACKET, &event[0], sizeof(event));
					res =TRUE;
				}
			}
			break;

		case EVENT_SUSPEND:
        case EVENT_RESUME:
        case EVENT_BUS_ERROR:
        default:
            break;
			
	}
	return res;
}

BYTE USBHostBTstackRead_Event()
{
    BYTE res = 0;
	
	if(startEvent == 1)
		return 0;
	
    res = USBHostRead( deviceAddress, USB_IN_EP|USB_EP1, (BYTE *)eventData, 32 );
    if (res == USB_SUCCESS)
    {
		log_info("USBHostBTstackRead_Event READ Start");
		startEvent = 1;
    }
    return res;	
}

BYTE USBHostBTStackRead_ACL()
{
    BYTE res = 0;
	
	if(startACL == 1)
		return 0;

    res = USBHostRead( deviceAddress, USB_IN_EP|USB_EP2, (BYTE *)aclData, 128 );
    if (res == USB_SUCCESS)
    {
		log_info("USBHostBTStackRead_ACL READ Start");
		startACL = 1;
    }
	
    return res;
	
}

// single instance

static hci_transport_t * hci_transport_usb = NULL;

static int pic32_open(void *transport_config){
    log_info("pic32_open");
    return 0;
}

static int pic32_close(void *transport_config){
    return 0;
}

static int pic32_can_send_packet_now(uint8_t packet_type){
    log_info("pic32_can_send_packet_now");
	int res = 0;
	switch (packet_type){
        case HCI_COMMAND_DATA_PACKET:
			res = 1;
			break;
        case HCI_ACL_DATA_PACKET:
			res = 1;
			break;
        default:
			break;
    }	
    return res;
}

static int pic32_send_packet(uint8_t packet_type, uint8_t * packet, int size){
	int i;
	log_info("usb_send_packet %d", packet_type);
	int res = 0;
    switch (packet_type){
        case HCI_COMMAND_DATA_PACKET:
			res = USBHostIssueDeviceRequest( deviceAddress, 
											USB_SETUP_HOST_TO_DEVICE|USB_SETUP_TYPE_CLASS|USB_SETUP_RECIPIENT_DEVICE, 
											0, 0, 0, size, (BYTE *)packet, USB_DEVICE_REQUEST_SET,0x00);

			break;
        case HCI_ACL_DATA_PACKET:
			res = USBHostWrite( deviceAddress, USB_OUT_EP|USB_EP2, (BYTE *)packet, size );
			break;
        default:
			res = -1;
			break;
    }
    return res;
}

static void pic32_register_packet_handler(void (*handler)(uint8_t packet_type, uint8_t *packet, uint16_t size)){
    log_info("registering packet handler");
    packet_handler = handler;
}

static const char * pic32_get_transport_name(void){
    return "PIC32";
}

static void dummy_handler(uint8_t packet_type, uint8_t *packet, uint16_t size){
}

// get usb singleton
hci_transport_t * hci_transport_pic32_instance() {
    if (!hci_transport_usb) {
        hci_transport_usb = (hci_transport_t*) malloc( sizeof(hci_transport_t));
        hci_transport_usb->open                          = pic32_open;
        hci_transport_usb->close                         = pic32_close;
        hci_transport_usb->send_packet                   = pic32_send_packet;
        hci_transport_usb->register_packet_handler       = pic32_register_packet_handler;
        hci_transport_usb->get_transport_name            = pic32_get_transport_name;
        hci_transport_usb->set_baudrate                  = NULL;
        hci_transport_usb->can_send_packet_now           = pic32_can_send_packet_now;
    }
    return hci_transport_usb;
}
