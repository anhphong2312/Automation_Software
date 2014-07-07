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


// Exported Functions:

extern "C" __declspec(dllexport) short CRC_value(EXT_ROUTINE_CONTROL* pERCtrl, char chars_to_CRC[]);


// Function declaration:

#define CRC_VERSION     "1.0"

#define FALSE           0
#define TRUE            1

unsigned short          update_crc_ccitt(  unsigned short crc, char c  );


// Function prototypes

unsigned short update_crc_ccitt( unsigned short crc, char c ) ;

static void init_crcccitt_tab( void ) ;
