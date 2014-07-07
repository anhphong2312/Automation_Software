#ifndef __RA_EXTROUTINE_H__
#define __RA_EXTROUTINE_H__

#define MAX_PARAMS 10

/*		MSC assumes LSB first, 32 bit integers		*/

#pragma pack(push,1)

struct RoutineControlWord			// 4 bytes (32 bit word) total
{
	unsigned ErrorCode : 8;			// Error code if ER bit is set
		// --end byte 0--
	unsigned NumParams : 8;			// From 0 to MAX_PARAMS, excludes control structure
		// --end byte 1--		
	unsigned ScanType : 2;			// 16-17 Normal, Post (0,1,2)
	unsigned ReservedA : 2;			// 18-19 Reserved Set A: DO NOT USE
	unsigned User : 2;				// 20-21 Defined by Ext Rtn developer
	unsigned ReservedC : 2;			// 22-23 Reserved Set C: DO NOT USE
		// --end byte 2--
	unsigned EnableIn : 1;			// 24 Incoming rung status
	unsigned EnableOut : 1;			// 25 Returning rung status
	unsigned FirstScan : 1;			// 26 First Normal Scan occurring 
	unsigned ER : 1;				// 27 Control ERROR
	unsigned ReservedB : 1;			// 28 Reserved Set B: DO NOT USE
	unsigned DN : 1;				// 29 Control DONE
	unsigned ReturnsValue : 1;		// 30 Indicates if routine returns anything
	unsigned EN : 1;				// 31 Control ENABLE
		// --end byte 3--
};

#pragma pack(pop)
enum EXT_ROUTINE_PARAM_TYPE_E		// 4 bytes long
{
	FloatingPointValue = 0,			// float p
	FloatingPointAddress,			// float *p
	IntegerValue,					// short p
	IntegerAddress,					// long* p
	ArrayAddress,					// int p[]
	StructureAddress,				// MyStructT* p
	VoidAddress,					// void* p
	Void,							// "No return value"
	LastEntryInEnum
};

// Structure representing the type of the parameter defined
// for the External Routine.
struct EXT_ROUTINE_PARAMETERS		// 12 bytes long
{
	// Size of paramete/array element in bits
	unsigned long bitsPerElement;

	// If array, number of elements else 1.
	unsigned long numberOfElements;

	// Numeric representation of reference type.
	EXT_ROUTINE_PARAM_TYPE_E paramType;
};

// Fixed size structure defining JXR's signature and control
struct EXT_ROUTINE_CONTROL		// 4 +120 +12 = 136 bytes long
{
	RoutineControlWord		ctrlWord;
	EXT_ROUTINE_PARAMETERS	paramDefs[MAX_PARAMS];
	EXT_ROUTINE_PARAMETERS	returnDef;
}; 
#endif