#include <windows.h>
#include <stdio.h>



//https://processhacker.sourceforge.io/doc/ntpsapi_8h_source.html#l00063
struct PEB_LDR_DATA
{
	ULONG Length;
	BOOLEAN Initialized;
	HANDLE SsHandle;
	LIST_ENTRY InLoadOrderModuleList;
	LIST_ENTRY InMemoryOrderModuleList;
	LIST_ENTRY InInitializationOrderModuleList;
	PVOID EntryInProgress;
	BOOLEAN ShutdownInProgress;
	HANDLE ShutdownThreadId;
};
//https://processhacker.sourceforge.io/doc/ntpebteb_8h_source.html#l00008
struct PEB
{
	BOOLEAN InheritedAddressSpace;
	BOOLEAN ReadImageFileExecOptions;
	BOOLEAN BeingDebugged;
	union
	{
		BOOLEAN BitField;
		struct
		{
			BOOLEAN ImageUsesLargePages : 1;
			BOOLEAN IsProtectedProcess : 1;
			BOOLEAN IsImageDynamicallyRelocated : 1;
			BOOLEAN SkipPatchingUser32Forwarders : 1;
			BOOLEAN IsPackagedProcess : 1;
			BOOLEAN IsAppContainer : 1;
			BOOLEAN IsProtectedProcessLight : 1;
			BOOLEAN SpareBits : 1;
		};
	};
	HANDLE Mutant;
	PVOID ImageBaseAddress;
	PEB_LDR_DATA* Ldr;
	//...
};

struct UNICODE_STRING
{
	USHORT Length;
	USHORT MaximumLength;
	PWCH Buffer;
};
	
//https://processhacker.sourceforge.io/doc/ntldr_8h_source.html#l00102
struct LDR_DATA_TABLE_ENTRY
{
	LIST_ENTRY InLoadOrderLinks;
	LIST_ENTRY InMemoryOrderLinks;
	union
	{
		LIST_ENTRY InInitializationOrderLinks;
		LIST_ENTRY InProgressLinks;
	};
	PVOID DllBase;
	PVOID EntryPoint;
	ULONG SizeOfImage;
	UNICODE_STRING FullDllName;
	UNICODE_STRING BaseDllName;
	//...
};


// Some str compare function, will prolly only compare first char for widechars
inline int ic_strcmp(char *s1, char *s2)
{
    int i;
    for (i = 0; s1[i] && s2[i]; ++i)
    {
        if (s1[i] == s2[i] || (s1[i] ^ 32) == s2[i])
           continue;
        else
           break;
    }
    if (s1[i] == s2[i])
        return 0;
    if ((s1[i] | 32) < (s2[i] | 32))
        return -1;
    return 1;
}



typedef BOOL (WINAPI * Sleep_t)(
  DWORD dwMilliseconds
);

typedef BOOL (WINAPI * AddVectoredExceptionHandler_t)(
  ULONG                       First,
  PVECTORED_EXCEPTION_HANDLER Handler
);

typedef HMODULE (WINAPI * LoadLibraryA_t)(
  LPCSTR lpLibFileName
);

// Decrypts two DES blocks with a 32 bit key... 
typedef NTSTATUS (WINAPI * SystemFunction025_t)(
  const BYTE* in,
  const BYTE* key,
  LPBYTE      out
);

typedef NTSTATUS (WINAPI * SystemFunction007_t)(
  const UNICODE_STRING *string,
  LPBYTE hash
);



typedef BOOL (WINAPI * SystemFunction036_t)(
  PVOID pbBuffer,
  ULONG dwLen
);



typedef struct
    {
        ULONG flag;
        UCHAR hash[20];
         ULONG state[5];
         ULONG count[2];
       UCHAR buffer[64];
    } A_SHA_CTX;



typedef VOID (WINAPI * pA_SHAInit_t)(
	A_SHA_CTX *Context
);

typedef VOID (WINAPI * pA_SHAUpdate_t)(
	A_SHA_CTX *Context,
	UCHAR *Input,
	ULONG Length
);

typedef VOID (WINAPI * pA_SHAFinal_t)(
	A_SHA_CTX *Context,
	UCHAR *Hash
);

typedef int (WINAPI * FoldStringW_t) (
	DWORD                         dwMapFlags,
	LPCWCH lpSrcStr,
	int                           cchSrc,
	LPWSTR                        lpDestStr,
	int                           cchDest
	);


typedef BOOL (WINAPI * FuckingBeep_t) (
	DWORD dwFreq,
	DWORD dwDuration
);



typedef HANDLE (WINAPI * CreateThread_t) (
	LPSECURITY_ATTRIBUTES   lpThreadAttributes,
	SIZE_T                  dwStackSize,
	LPTHREAD_START_ROUTINE  lpStartAddress,
	LPVOID lpParameter,
	DWORD                   dwCreationFlags,
	LPDWORD                 lpThreadId
	);


inline unsigned long rollingHash(unsigned char *str, int len)
{
    unsigned long hash = 73;
    int c;

    while (len > 0) {
        c = *str++;
        hash = (((hash << 5) + hash) + c) % 2147483647;
        len -= 1;
    }

    return hash;
}

DWORD WINAPI dothings( LPVOID lpParam ) {
	FuckingBeep_t pBeep = *((FuckingBeep_t*)lpParam);
	DWORD ret = (DWORD) pBeep(900, 10000);

	return ret;
}


#define BEEP_HASH 89057509
#define CREATETHREAD_HASH 0x34d3d2f8


#define KERNEL32HASH 0x06AF61C1 // 0x28ca5029
DWORD * getAddressOfKernel32FunctionByHash(unsigned long hash, int len) {

	// Walk PEB
	PEB * ProcEnvBlk = (PEB *) __readfsdword(0x30);
	PEB_LDR_DATA * Ldr = ProcEnvBlk->Ldr;
	LIST_ENTRY * ModuleList = NULL;
	
	ModuleList = &Ldr->InMemoryOrderModuleList;
	LIST_ENTRY *  pStartListEntry = ModuleList->Flink;

	// Loop loaded modules
	for (LIST_ENTRY *  pListEntry  = pStartListEntry;
					   pListEntry != ModuleList;
					   pListEntry  = pListEntry->Flink)	{
		
		LDR_DATA_TABLE_ENTRY * pEntry = (LDR_DATA_TABLE_ENTRY *) ((BYTE *) pListEntry - sizeof(LIST_ENTRY)); // get current Data Table Entry

		// Have Kernel32?
		if (rollingHash((unsigned char*)pEntry->BaseDllName.Buffer, 24) == KERNEL32HASH && ProcEnvBlk->BeingDebugged == 0) {

			char* pBaseAddr = (char*) pEntry->DllBase;

			// get pointers to main headers/structures, resolve addresses to Export Address Table, table of function names and "table of ordinals"
			IMAGE_DOS_HEADER * pDosHdr = (IMAGE_DOS_HEADER *) pBaseAddr;
			IMAGE_NT_HEADERS * pNTHdr = (IMAGE_NT_HEADERS *) (pBaseAddr + pDosHdr->e_lfanew);
			IMAGE_OPTIONAL_HEADER * pOptionalHdr = &pNTHdr->OptionalHeader;
			IMAGE_DATA_DIRECTORY * pExportDataDir = (IMAGE_DATA_DIRECTORY *) (&pOptionalHdr->DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT]);
			IMAGE_EXPORT_DIRECTORY * pExportDirAddr = (IMAGE_EXPORT_DIRECTORY *) (pBaseAddr + pExportDataDir->VirtualAddress);

			DWORD * pEAT = (DWORD *) (pBaseAddr + pExportDirAddr->AddressOfFunctions);
			DWORD * pFuncNameTbl = (DWORD *) (pBaseAddr + pExportDirAddr->AddressOfNames);
			WORD * pHintsTbl = (WORD *) (pBaseAddr + pExportDirAddr->AddressOfNameOrdinals);

			// Search kernel32 for beep
			for (DWORD i = 0; i < pExportDirAddr->NumberOfNames; i++) {

				if (rollingHash((unsigned char *) pBaseAddr + (DWORD_PTR) pFuncNameTbl[i], len) == hash) {
					return (DWORD *)(pBaseAddr + ProcEnvBlk->BeingDebugged + (DWORD_PTR) pEAT[pHintsTbl[i]]);
				}
			}
		}
	}

	return NULL;

}


#define BEEP_HASH 89057509
#define CREATETHREAD_HASH 0x34d3d2f8

int WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nShowCmd){
// int __stdcall WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
// int main() {

	FuckingBeep_t pBeep = (FuckingBeep_t) getAddressOfKernel32FunctionByHash(BEEP_HASH, 4);
	CreateThread_t pCreateThread = (CreateThread_t) getAddressOfKernel32FunctionByHash(CREATETHREAD_HASH, 12);

	
	HANDLE h = pCreateThread(NULL, 0, dothings, &pBeep, 0, NULL);
	BOOL ret = pBeep(800, 4000);
	
	

	return ret;
}

