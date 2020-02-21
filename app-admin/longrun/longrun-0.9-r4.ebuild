# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-info toolchain-funcs

DESCRIPTION="A utility to control Transmeta's Crusoe and Efficeon processors"
HOMEPAGE="http://freshmeat.net/projects/longrun/"

DEBIAN_PATCH_VERSION="19"
DEBIAN_PATCH="${PN}_${PV}-${DEBIAN_PATCH_VERSION}.diff"
SRC_URI="
	https://www.kernel.org/pub/linux/utils/cpu/crusoe/${P}.tar.bz2
	mirror://debian/pool/main/l/${PN}/${DEBIAN_PATCH}.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-ppc x86"
IUSE=""

DEPEND="sys-apps/groff"

S=${WORKDIR}/${PN}

CONFIG_CHECK="~X86_MSR ~X86_CPUID"
ERROR_X86_MSR="
Longrun needs a MSR device to function. Please select
MSR under Processor type and features. It can be build
directly into the kernel or as a module."
ERROR_X86_CPUID="
Longrun needs a CPUID device to function. Please select
CPUID under Processor type and features. It can be
build directly into the kernel or as a module."

PATCHES=(
	"${WORKDIR}"/${DEBIAN_PATCH}
	"${FILESDIR}"/${PV}-makefile_cflags.patch
	"${FILESDIR}"/${PV}-replace-loff_t.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	default
	dodoc MAKEDEV-cpuid-msr
}

pkg_postinst() {
	if linux_config_exists; then
		if linux_chkconfig_module X86_MSR; then
			elog "You have compiled MSR as a module."
			elog "You need to load it before using Longrun."
			elog "The module is called msr."
			elog
		fi

		if linux_chkconfig_module X86_CPUID; then
			elog "You have compiled CPUID as a module."
			elog "You need to load it before using Longrun."
			elog "The module is called cpuid."
		fi
	else
		elog "You have no kernel configuration available."
		elog "Longrun needs both CPUID and MSR capabilites,"
		elog "in the kernel you intend to run it under."
	fi
}
