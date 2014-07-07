#include "stdafx.h"
#include <stdio.h>		/* printf */ 
#include <stdlib.h>
#include <string.h>
#include <iostream>


// Include file for External Routine interface
#include "RA_ExternalRoutines.h"
#include "crc_genibus.h"

#pragma warning (disable : 4996) // file writing, to disable deprecation, _CRT_SECURE_NO_WARNINGS 


/****************************************************************************************/
/****************************************************************************************/
/****************************************************************************************/


BOOL APIENTRY DllMain( HANDLE hModule,
					  DWORD	ul_reason_for_call,
					  LPVOID lpReserved
					  )
{
	switch (ul_reason_for_call)
	{
		case DLL_PROCESS_ATTACH:
		case DLL_THREAD_ATTACH:
		case DLL_THREAD_DETACH:
		case DLL_PROCESS_DETACH:
			break;
	}
	return TRUE;
}

/****************************************************************************************/
/****************************************************************************************/
/****************************************************************************************/


__declspec(dllexport) short CRC_value(EXT_ROUTINE_CONTROL* pERCtrl, 
										 char chars_to_CRC[])
{
	// Run all array elements provided thru CRC algorithm, then return the CRC value.
	pERCtrl->ctrlWord.EN = pERCtrl->ctrlWord.EnableIn;
	pERCtrl->ctrlWord.EnableOut = pERCtrl->ctrlWord.EnableIn;
	
	
	BOOL bFail = FALSE;

	// Number of parameters expected is 1 (exclude ctrl struct*), and 
	// Check type of parameter against what is expected, and
	// Check size of array elements to make sure they agree with CHAR type.
	if (pERCtrl->ctrlWord.NumParams !=1)
	{
		bFail = TRUE;
	}
	else if ( (pERCtrl->paramDefs[0].paramType !=ArrayAddress) ||
		(pERCtrl->paramDefs[0].bitsPerElement != 8*sizeof(char)) )
		bFail = TRUE;

	// Check number of array elements
	int nNoElems = pERCtrl->paramDefs[0].numberOfElements;

	if (nNoElems ==0)
		bFail = TRUE;

	/***************************************/
	char hex_val, *ptr;
	unsigned short crc_ccitt_ffff;			// start with 0xFFFF
	int count =0;

	crc_ccitt_ffff = 0xffff;
	ptr = chars_to_CRC;

	// debugging
	FILE *f=fopen("C:\\debug.txt","a");

	// update nNoElems
	nNoElems = (chars_to_CRC[0]*16 +chars_to_CRC[1] +1)*2 ;		// read the length byte and plus itself

	if (pERCtrl->ctrlWord.EnableIn)
	{
		// Rung enabled, run the function's implementation
		if (!bFail) 
		{
			// Run all array elements thru the algorithm
			while (  (*ptr !='\x80')  && (count < (nNoElems/2))  )
			{
				//fprintf(f, "DEBUG j: %d\n", j);
				hex_val = (char) ( (*ptr & '\x0f')  << 4  );
				hex_val |= (char) ( (*(ptr+1) & '\x0f') );
				//fprintf(f, "DEBUG hex_val: %4x\n", hex_val);
				crc_ccitt_ffff = update_crc_ccitt(  crc_ccitt_ffff, hex_val );
	            //fprintf(f, "DEBUG crc_ccitt_ffff: %4x\n", crc_ccitt_ffff);
				ptr		+=	2;
				count	++;
			}

			
			// Set Error bit to zero if succesful
			pERCtrl->ctrlWord.ER = 0;
		}
		else 
		{
			// Some error
			// Set Error bit to indicate error occurred
			pERCtrl->ctrlWord.ER =1;
			pERCtrl->ctrlWord.ErrorCode=1; // Set ErrorCode
		}

		//Set Done bit before exit of this XR
		pERCtrl->ctrlWord.DN=1;
	}
	else
	{
		// Rung not enabled
		pERCtrl->ctrlWord.DN = 0;
	}

	fclose(f);
	return crc_ccitt_ffff; // Return 0.0 if error
	//return (short) hex_val;
}