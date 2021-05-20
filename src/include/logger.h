#pragma once

#ifdef POWERPC64_PS3_ELF
#include <dbglogger.h>

#define LOG dbglogger_log
#endif

#ifndef LOG
#include <stdio.h>

#define LOG printf
#endif

