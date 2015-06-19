# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/phc-k8/phc-k8-0.4.3.ebuild,v 1.2 2011/11/18 08:45:18 xmw Exp $

EAPI=4

inherit linux-info linux-mod

DESCRIPTION="Processor Hardware Control for AMD K8 CPUs"
HOMEPAGE="http://www.linux-phc.org/"
SRC_URI="http://www.linux-phc.org/forum/download/file.php?id=107 -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${PN}_v${PV}

pkg_pretend() {
	if kernel_is gt 3 0 0 ; then
		eerror "This version is not compartible with linux 3.x (bug 376441)"
		eerror "Please use >=sys-power/phc-k8-0.4.4 !"
		einfo ; einfo ; einfo
		die "wrong kernel version"
	fi
}

pkg_setup() {
	CONFIG_CHECK="~!X86_POWERNOW_K8"
	ERROR_X86_POWERNOW_K8="CONFIG_X86_POWERNOW_K8 should be configured to Module, to
a) include needed symbol cpufreq_get_measured_perf and
b) enable the replacemant of powernow-k8 with phc-k8."

	MODULE_NAMES="phc-k8(misc:)"
	BUILD_PARAMS="KERNELSRC=\"${KERNEL_DIR}\" -j1"
	BUILD_TARGETS="all"
}

src_install() {
	linux-mod_src_install
	dodoc Changelog README || die
}
