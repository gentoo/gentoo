# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit flag-o-matic linux-mod

DESCRIPTION="IBM ThinkPad SMAPI BIOS driver"
HOMEPAGE="https://github.com/evgeni/tp_smapi/ http://tpctl.sourceforge.net/"
SRC_URI="mirror://github/evgeni/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="hdaps"

RESTRICT="userpriv"

# We need dmideode if the kernel does not support DMI_DEV_TYPE_OEM_STRING
# in dmi.h
DEPEND="sys-apps/dmidecode"
RDEPEND="${DEPEND}"

pkg_pretend() {
	linux-mod_pkg_setup

	if kernel_is lt 2 6 19; then
		eerror
		eerror "${P} requires Linux kernel 2.6.19 or above."
		eerror
		die "Unsupported kernel version"
	fi

	MODULE_NAMES="thinkpad_ec(extra:) tp_smapi(extra:)"
	BUILD_PARAMS="KSRC=${KV_DIR} KBUILD=${KV_OUT_DIR}"
	BUILD_TARGETS="default"

	if use hdaps; then
		CONFIG_CHECK="~INPUT_UINPUT"
		WARNING_INPUT_UINPUT="Your kernel needs uinput for the hdaps module to perform better"
		linux-info_pkg_setup

		MODULE_NAMES="${MODULE_NAMES} hdaps(extra:)"
		BUILD_PARAMS="${BUILD_PARAMS} HDAPS=1"

		CONFIG_CHECK="~!SENSORS_HDAPS"
		ERROR_SENSORS_HDAPS="${P} with USE=hdaps conflicts with in-kernel HDAPS (CONFIG_SENSORS_HDAPS)"
		linux-info_pkg_setup
	fi
}

pkg_setup() {
	# run again as pkg_pretend is not var safe
	pkg_pretend
}

src_compile() {
	# Kernel Makefiles may pull in -mpreferred-stack-boundary=3
	# which requires that SSE disabled or compilation will fail.
	# So we need to ensure that appended user CLAGS do not re-enable SSE
	# https://bugs.gentoo.org/show_bug.cgi?id=492964
	replace-flags '-msse*' ''
	replace-flags '-mssse3' ''

	linux-mod_src_compile
}

src_install() {
	linux-mod_src_install
	dodoc CHANGES README
	newinitd "${FILESDIR}"/${PN}-0.40-initd smapi
	newconfd "${FILESDIR}"/${PN}-0.40-confd smapi
}
