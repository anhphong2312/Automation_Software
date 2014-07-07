#define _CRT_SECURE_NO_WARNINGS		// to be able to use f_open
									// http://stackoverflow.com/questions/14448433/error-c4996-fopen-not-declared


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <iostream>

// Users header
#include "crc_genibus.h"

// 
#define MAX_STRING_SIZE 2048

    /*******************************************************************\
    *                                                                   *
    *   File            : test_crc.c                                    *
    *   Author          : Phong Pham, 2014								*
    *   E-mail          : phong.pham@apmtinc.com                        *
    *   Language        : C++                                           *
    *   Date updated	: 01/18/2014                                    *
    *	Current version	: 1.0											*
	*                                                                   *
    *   Description                                                     *
    *   ===========                                                     *
    *                                                                   *
    *   The file test_crc.c contains a small  sample  program  which    *
    *   demonstrates  the  use of the functions for calculating the     *
    *   CRC-CCITT values of data. The file  calculates  the CRC's for   *
	*   a file who's name is CRC_test_in.txt and output to				*
	*	CRC_test_out.txt											    *
    *																	*
	*	The original source code is borrowed from Lammert Bies at		*
	*	info@lammertbies.nl			                                    *
    *                                                                   *
    *   Dependencies                                                    *
    *   ============                                                    *
    *                                                                   *
    *   lib_crc.h       original CRC definitions and prototypes         *
    *   lib_crc.c       original CRC routines                           *
    *   crc_genibus.h	CRC definitions and prototypes                  *
    *	crc_genibus.c	CRC routines and run codes						*
	*                                                                   *
    *   Modification history                                            *
    *   ====================                                            *
	*                                                                   *
    \*******************************************************************/

   /*******************************************************************\
    *                                                                   *
    *   #define P_CCITT                                                 *
    *                                                                   *
    *   The CRC's are computed using polynomials. The  coefficients     *
    *   for the algorithms are defined by the following constants.      *
    *   The polynomial is 0x1021 = x^16 +x^12 +x^5 +1					*
	*																	*
    \*******************************************************************/
#define                 P_CCITT     0x1021

    /*******************************************************************\
    *                                                                   *
    *   static int crc_tab...init                                       *
    *   static unsigned ... crc_tab...[]                                *
    *                                                                   *
    *   The algorithms use tables with precalculated  values.  This     *
    *   speeds  up  the calculation dramaticaly. The first time the     *
    *   CRC function is called, the table for that specific  calcu-     *
    *   lation  is set up. The ...init variables are used to deter-     *
    *   mine if the initialization has taken place. The  calculated     *
    *   values are stored in the crc_tab... arrays.                     *
    *                                                                   *
    *   The variables are declared static. This makes them  invisi-     *
    *   ble for other modules of the program.                           *
    *                                                                   *
    \*******************************************************************/

static int              crc_tabccitt_init       = FALSE;

static unsigned short   crc_tabccitt[256];

    /*******************************************************************\
    *                                                                   *
    *   static void init_crc...tab();                                   *
    *                                                                   *
    *   This local function are used  to  initialize  the  tables       *
    *   with values for the algorithm.                                  *
    *                                                                   *
    \*******************************************************************/

static void             init_crcccitt_tab( void );

   /*******************************************************************\
    *                                                                   *
    *   unsigned short update_crc_ccitt( unsigned long crc, char c );   *
    *                                                                   *
    *   The function update_crc_ccitt calculates  a  new  CRC-CCITT     *
    *   value  based  on the previous value of the CRC and the next     *
    *   byte of the data to be checked.                                 *
    *                                                                   *
    \*******************************************************************/

unsigned short update_crc_ccitt( unsigned short crc, char c ) 
{
    unsigned short tmp, short_c;

    short_c  = 0x00ff & (unsigned short) c;

    if ( ! crc_tabccitt_init ) init_crcccitt_tab();

    tmp = (crc >> 8) ^ short_c;
    crc = (crc << 8) ^ crc_tabccitt[tmp];

    return crc;

}  /* update_crc_ccitt */

    /*******************************************************************\
    *                                                                   *
    *   static void init_crcccitt_tab( void );                          *
    *                                                                   *
    *   The function init_crcccitt_tab() is used to fill the  array     *
    *   for calculation of the CRC-CCITT with values.                   *
    *                                                                   *
    \*******************************************************************/

static void init_crcccitt_tab( void ) 
{
    int i, j;
    unsigned short crc, c;

    for (i=0; i<256; i++) {

        crc = 0;
        c   = ((unsigned short) i) << 8;

        for (j=0; j<8; j++) {

            if ( (crc ^ c) & 0x8000 ) crc = ( crc << 1 ) ^ P_CCITT;
            else                      crc =   crc << 1;

            c = c << 1;
        }

        crc_tabccitt[i] = crc;
    }

    crc_tabccitt_init = TRUE;

}  /* init_crcccitt_tab */

    

	/*******************************************************************\
    *                                                                   *
    *   void main( int arge, char*argv[])		                        *
    *                                                                   *
    *   for testing purpose								                *
    *                                                                   *
    \*******************************************************************/

/*
#define MAX_STRING_SIZE 13

void main( int arge, char*argv[])
{
	unsigned short crc_ccitt_ffff;			// start with 0xFFFF
	char hex_val, *ptr;
	char input_string[MAX_STRING_SIZE] = "056401038105";
	int count=0;

    printf( "\nCRC algorithm sample program,\n Version %s", CRC_VERSION, "\n\n" );

	crc_ccitt_ffff = 0xffff;
	ptr = input_string;
	
	while (  (*ptr !='\x80') && (count < (MAX_STRING_SIZE/2))  )
	{
		hex_val = (char) ( (*ptr & '\x0f')  << 4  );
		hex_val |= (char) ( (*(ptr+1) & '\x0f') );
		crc_ccitt_ffff = update_crc_ccitt(  crc_ccitt_ffff, hex_val );
		ptr		+=	2;
		count ++;
	}
	
	printf("\n0x%04X", crc_ccitt_ffff);

}	/* main (Main_code) */
