# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/phc-intel/phc-intel-0.3.2.12.15.1.ebuild,v 1.1 2014/07/22 00:13:05 xmw Exp $

EAPI=5

inherit linux-info linux-mod eutils

DESCRIPTION="Processor Hardware Control for Intel CPUs"
HOMEPAGE="http://www.linux-phc.org/
	http://www.linux-phc.org/forum/viewtopic.php?f=7&t=267"
#no automatic filenames here, sorry
SRC_URI="http://www.linux-phc.org/forum/download/file.php?id=161 -> phc-intel-pack-rev15.1.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CONFIG_CHECK="~!X86_ACPI_CPUFREQ"
ERROR_X86_ACPI_CPUFREQ="CONFIG_X86_ACPI_CPUFREQ has to be configured to Module to enable the replacement of acpi-cpufreq with phc-intel."

MODULE_NAMES="phc-intel(misc:)"
BUILD_PARAMS="KERNELSRC=\"${KERNEL_DIR}\" -j1"
BUILD_TARGETS="all"

S=${WORKDIR}/${A/.tar.bz2}

pkg_setup() {
	if kernel_is lt 2 6 27 ; then
		eerror "Your kernel version is no longer supported by this version of ${PN}."
		eerror "Please use a previous version of ${PN} or a newer kernel."
		die
	fi
	if kernel_is gt 3 15 ; then
		eerror "Your kernel version is not yet supported by this version of ${PN}."
		eerror "Please use a newer version of ${PN} or an older kernel."
		die
	fi
	linux-mod_pkg_setup
}

src_prepare() {
	epatch \
		"${FILESDIR}"/phc-intel-0.3.2-rev12-trailing-space-misc.patch \
		"${FILESDIR}"/phc-intel-0.3.2-rev15-trailing-space-3.5.patch \
		"${FILESDIR}"/phc-intel-0.3.2-rev14-trailing-space-3.13.patch \
		"${FILESDIR}"/phc-intel-0.3.2-rev14-trailing-space-3.14.patch \
		"${FILESDIR}"/phc-intel-0.3.2-rev15-trailing-space-3.15.patch

	sed -e '/^all:/s:prepare::' \
		-i Makefile || die

	local my_sub=arch/x86/kernel/cpu
	if kernel_is gt 2 6 39 ; then
		my_sub=drivers
	fi
	cp -v "${KERNEL_DIR}"/${my_sub}/cpufreq/acpi-cpufreq.c . || die
	if kernel_is lt 3 12 ; then
		cp -v "${KERNEL_DIR}"/${my_sub}/cpufreq/mperf.h . || die
	fi

	if kernel_is lt 3 0 ; then
		epatch inc/${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}/linux-phc-0.3.2.patch
	else
		epatch inc/${KV_MAJOR}.${KV_MINOR}/linux-phc-0.3.2.patch
	fi

	mv acpi-cpufreq.c phc-intel.c || die
}
