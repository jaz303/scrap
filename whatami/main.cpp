#include <iostream.h>
#include <windows.h>
#include <pdh.h>
#include <pdhmsg.h>
#include <tlhelp32.h>
#include "psapi.h"

int GetCPUSpeed(void);
_inline unsigned __int64 GetCycleCount(void);
BOOL GetCurrentUserAndDomain(PTSTR szUser, PDWORD pcchUser, PTSTR szDomain, PDWORD pcchDomain);
void PrintProcessNameAndID( DWORD processID );

int main()
{
	cout << "<?xml version=\"1.0\"?>" << endl << "<computer>" << endl << "  <processors>" << endl;
	
	/*
		Number of processors
	*/
	HKEY hKey;
	long result;
	unsigned int procCount;
	result = ::RegOpenKeyEx (HKEY_LOCAL_MACHINE,"Hardware\\Description\\System\\CentralProcessor\\1", 0, KEY_QUERY_VALUE, &hKey);
	procCount = (result == ERROR_SUCCESS) ? 2 : 1;
	cout << "    <count>" << procCount << "</count>" << endl;
	RegCloseKey (hKey);

	/*
		Estimated speed
	*/
	cout << "    <estimated_speed>" << GetCPUSpeed() << " MHz" << "</estimated_speed>" << endl;
	
	/*
		Reported info
	*/
	DWORD dataSize;
	UCHAR data[257];
	DWORD reportedSpeed;
	
	result = ::RegOpenKeyEx (HKEY_LOCAL_MACHINE,"Hardware\\Description\\System\\CentralProcessor\\0", 0, KEY_QUERY_VALUE, &hKey);
	if (result == ERROR_SUCCESS) {
		dataSize = sizeof(reportedSpeed);
		result = ::RegQueryValueEx (hKey, "~MHz", NULL, NULL,(LPBYTE)&reportedSpeed, &dataSize);
		cout << "    <reported_speed>" << reportedSpeed << " MHz</reported_speed>" << endl;

		dataSize = sizeof(data);
		result = ::RegQueryValueEx (hKey, "VendorIdentifier", NULL, NULL, (LPBYTE)&data, &dataSize);
		cout << "    <vendor_id>" << data << "</vendor_id>" << endl;

		dataSize = sizeof(data);
		result = ::RegQueryValueEx (hKey, "Identifier", NULL, NULL, (LPBYTE)&data, &dataSize);
		cout << "    <id>" << data << "</id>" << endl;

	} else {
		cout << "    <reported_speed>N/A</reported_speed>" << endl;
		cout << "    <vendor_id>N/A</vendor_id>" << endl;
		cout << "    <id>N/A</id>" << endl;
	}
	RegCloseKey (hKey);

	cout << "  </processors>" << endl;

	/*
		Memory
	*/
	cout << "  <memory>" << endl;

	MEMORYSTATUS ms;
	GlobalMemoryStatus(&ms);
	cout << "    <total_physical>" << (ms.dwTotalPhys >> 10) << " Kb</total_physical>" << endl;
	cout << "    <available_physical>" << (ms.dwAvailPhys >>10) << " Kb</available_physical>" << endl;
	cout << "    <total_pagefile>" << (ms.dwTotalPageFile >> 10) << " Kb</total_pagefile>" << endl;
	cout << "    <available_pagefile>" << (ms.dwAvailPageFile >> 10) << " Kb</available_pagefile>" <<endl;
	
	cout << "  </memory>" << endl;

	/*
		OS version
	*/
	cout << "  <OS>" << endl;
	
	OSVERSIONINFO os;
	os.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);
	GetVersionEx(&os);
	cout << "    <platform>";
	
	char platform_id = 0;

	if (os.dwPlatformId == VER_PLATFORM_WIN32s) {
		cout << "Windows 3.1";
		platform_id = 1;
	}
	if (os.dwPlatformId == VER_PLATFORM_WIN32_WINDOWS) {
		cout << "Windows 9x";
		platform_id = 2;
	}
	if (os.dwPlatformId == VER_PLATFORM_WIN32_NT) {
		cout << "Windows NT";
		platform_id = 3;
	}

	cout << "</platform>" << endl;
	cout << "    <version>" << os.dwMajorVersion << "." << os.dwMinorVersion << "</version>" << endl;
	cout << "    <build>" << os.dwBuildNumber << "</build>" << endl;

	cout << "  </OS>" << endl;

	/*
		Uptime
	*/
	cout  << "  <uptime>" << endl;
	DWORD uptime = GetTickCount();
	DWORD upsecs =  uptime/1000;
	DWORD hours = upsecs/3600;
	DWORD minutes = (upsecs % 3600) / 60;
	DWORD seconds = (upsecs % 3600) % 60;
	cout << "    <time>" << hours << "h " << minutes << "m " << seconds << "s</time>" << endl;
	cout << "    <ticks>" << uptime << "</ticks>" << endl;

	cout << "  </uptime>" << endl;

	cout << "  <environment>" << endl;

	/*
		Username
	*/
	cout << "    <username>";

	char user[50];
	char domain[100];

	unsigned long userlen = 50;
	unsigned long domainlen = 100;

	if (! GetCurrentUserAndDomain((PTSTR)user,&userlen,(PTSTR)domain,&domainlen)) {
		cout << "N/A</username>" << endl << "    <domain>N/A</domain>" << endl;
	} else {
		cout << user << "</username>" << endl << "    <domain>" << domain << "</domain>" << endl;
	}

	/*
		CPU load
	*/
	cout << "    <cpu_load>";
	DWORD cpu_usage;
	
	if (platform_id < 2) {
		cout << "N/A";
	}
	
	if (platform_id == 2) {
		result = ::RegOpenKeyEx (HKEY_DYN_DATA,"PerfStats\\StatData", 0, KEY_ALL_ACCESS, &hKey);
		if (result == ERROR_SUCCESS) {
			result = ::RegQueryValueEx (hKey, "KERNEL\\CPUUsage", NULL, NULL,(LPBYTE)&cpu_usage, &dataSize);
			cout << cpu_usage;
		} else {
			cout << "N/A";
		}
		RegCloseKey (hKey);
	}

	if (platform_id == 3) {
		cout << "N/A";
	}


	cout << "</cpu_load>" << endl;
	
	/*
		Processes
	*/
	cout << "    <processes>" << endl;

	HANDLE hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0);
	if (hSnapshot == INVALID_HANDLE_VALUE) {
		cout << endl << endl << "Fatal error: unable to create process snapshot" << endl;
		return (0);
	}

	PROCESSENTRY32 pe;
	pe.dwSize=sizeof(PROCESSENTRY32);

	BOOL retval = Process32First(hSnapshot,&pe);
	unsigned int proc_count = 0;
	while(retval) {
		//cout << "      <process>" << pe.th32ProcessID << "</process>" << endl;
		PrintProcessNameAndID(pe.th32ProcessID);
		pe.dwSize=sizeof(PROCESSENTRY32);
		retval=Process32Next(hSnapshot,&pe);
		proc_count++;
	}

	CloseHandle(hSnapshot);

	cout << "    </processes>" << endl;
	cout << "    <process_count>" << proc_count << "</process_count>" << endl;

	cout << "  </environment>" << endl;

	
	cout << "</computer>" << endl;

	return (0);
}

// Code to work out CPU speed
// Taken from: http://www.codeguru.com/mfc/comments/20416.shtml
// (c) Michael Tan (2001)

_inline unsigned __int64 GetCycleCount(void)
{
    _asm    _emit 0x0F
    _asm    _emit 0x31
}

int GetCPUSpeed(void)
{
	unsigned __int64  m_startcycle;
	unsigned __int64  m_res;
	unsigned __int64  m_overhead;
	unsigned cpuspeed10;
        m_overhead = 0;

	m_startcycle = GetCycleCount();

	Sleep(1000); 
	m_res = GetCycleCount()-m_startcycle-m_overhead;

	cpuspeed10 = (unsigned)(m_res/100000);
	cpuspeed10 = cpuspeed10/10;

	return cpuspeed10;
}

// End CPU speed code

BOOL GetCurrentUserAndDomain(PTSTR szUser, PDWORD pcchUser, 
      PTSTR szDomain, PDWORD pcchDomain) {

   BOOL         fSuccess = FALSE;
   HANDLE       hToken   = NULL;
   PTOKEN_USER  ptiUser  = NULL;
   DWORD        cbti     = 0;
   SID_NAME_USE snu;

   __try {

      // Get the calling thread's access token.
      if (!OpenThreadToken(GetCurrentThread(), TOKEN_QUERY, TRUE, &hToken)) {

         if (GetLastError() != ERROR_NO_TOKEN)
            __leave;

         // Retry against process token if no thread token exists.
         if (!OpenProcessToken(GetCurrentProcess(), TOKEN_QUERY, 
               &hToken))
            __leave;
      }

      // Obtain the size of the user information in the token.
      if (GetTokenInformation(hToken, TokenUser, NULL, 0, &cbti)) {

         // Call should have failed due to zero-length buffer.
         __leave;
   
      } else {

         // Call should have failed due to zero-length buffer.
         if (GetLastError() != ERROR_INSUFFICIENT_BUFFER)
            __leave;
      }

      // Allocate buffer for user information in the token.
      ptiUser = (PTOKEN_USER) HeapAlloc(GetProcessHeap(), 0, cbti);
      if (!ptiUser)
         __leave;

      // Retrieve the user information from the token.
      if (!GetTokenInformation(hToken, TokenUser, ptiUser, cbti, &cbti))
         __leave;

      // Retrieve user name and domain name based on user's SID.
      if (!LookupAccountSid(NULL, ptiUser->User.Sid, szUser, pcchUser, 
            szDomain, pcchDomain, &snu))
         __leave;
      
      fSuccess = TRUE;

   } __finally {

      // Free resources.
      if (hToken)
         CloseHandle(hToken);

      if (ptiUser)
         HeapFree(GetProcessHeap(), 0, ptiUser);
   }

   return fSuccess;
}

void PrintProcessNameAndID( DWORD processID )
{
    char szProcessName[MAX_PATH] = "unknown";

    // Get a handle to the process.

    HANDLE hProcess = OpenProcess( PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, FALSE, processID );

    // Get the process name.

    if (NULL != hProcess ) {
        HMODULE hMod;
        DWORD cbNeeded;

        if ( EnumProcessModules( hProcess, &hMod, sizeof(hMod), &cbNeeded) ) {
            GetModuleBaseName( hProcess, hMod, szProcessName, sizeof(szProcessName) );
        }
        else return;
    }
    else return;

    // Print the process name and identifier.
		cout << "      <process>" << endl;
    cout << "        <process_id>" << processID << "</process_id>" << endl;
		cout << "        <process_name>" << szProcessName << "</process_name>" << endl;
		cout << "      </process>" << endl;

    CloseHandle( hProcess );
}
