/*
 *  linux/init/version.c
 *
 *  Copyright (C) 1992  Theodore Ts'o
 *
 *  May be freely distributed as part of Linux.
 */

#include <generated/compile.h>
#include <linux/module.h>
#include <linux/uts.h>
#include <linux/utsname.h>
#include <generated/utsrelease.h>
#include <linux/version.h>
#include <linux/proc_ns.h>

#ifndef CONFIG_KALLSYMS
#define version(a) Version_ ## a
#define version_string(a) version(a)

extern int version_string(LINUX_VERSION_CODE);
int version_string(LINUX_VERSION_CODE);
#endif

#ifdef CONFIG_SPOOF_KERNEL_VERSION
#define FIXED_UTS_VERSION CONFIG_SPOOF_KERNEL_VERSION_STRING
#define FIXED_LINUX_BANNER \
	"Linux version " UTS_RELEASE " (builder@whyred) " \
	"(gcc version 4.9.x 20150123 (prerelease)) " FIXED_UTS_VERSION "\n"
#endif

struct uts_namespace init_uts_ns = {
	.kref = KREF_INIT(2),
	.name = {
		.sysname    = UTS_SYSNAME,
		.nodename   = UTS_NODENAME,
		.release    = UTS_RELEASE,
#ifdef CONFIG_SPOOF_KERNEL_VERSION
		.version    = FIXED_UTS_VERSION,
#else
		.version    = UTS_VERSION,
#endif
		.machine    = UTS_MACHINE,
		.domainname = UTS_DOMAINNAME,
	},
	.user_ns = &init_user_ns,
	.ns.inum = PROC_UTS_INIT_INO,
#ifdef CONFIG_UTS_NS
	.ns.ops = &utsns_operations,
#endif
};
EXPORT_SYMBOL_GPL(init_uts_ns);

#ifdef CONFIG_SPOOF_KERNEL_VERSION
const char linux_banner[] = FIXED_LINUX_BANNER;
#else
/* FIXED STRINGS! Don't touch! */
const char linux_banner[] =
	"Linux version " UTS_RELEASE " (" LINUX_COMPILE_BY "@"
	LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION "\n";
#endif

const char *linux_banner_ptr = linux_banner;
EXPORT_SYMBOL_GPL(linux_banner_ptr);

const char linux_proc_banner[] =
	"%s version %s"
	" (" LINUX_COMPILE_BY "@" LINUX_COMPILE_HOST ")"
	" (" LINUX_COMPILER ") %s\n";

