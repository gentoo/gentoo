# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic linux-mod

DESCRIPTION="IBM ThinkPad SMAPI BIOS driver"
HOMEPAGE="https://github.com/evgeni/${PN}"
SRC_URI="${HOMEPAGE}/releases/download/tp-smapi/${PV}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="hdaps"

# We need dmideode if the kernel does not support
# DMI_DEV_TYPE_OEM_STRING in dmi.h.
DEPEND="sys-apps/dmidecode"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/linux-4.15-timer_setup-fix.patch" )

# This code is factored out of both pkg_pretend() and pkg_setup()
# because the PMS states that ebuilds may not call phase functions
# directly (see the "List of functions" section). This was bug #596616
# and #596622.
tp_smapi_pkg_pretend() {
	linux-mod_pkg_setup

	MODULE_NAMES="thinkpad_ec(extra:) tp_smapi(extra:)"
	BUILD_PARAMS="KSRC=${KV_DIR} KBUILD=${KV_OUT_DIR}"
	BUILD_TARGETS="default"

	if use hdaps; then
		CONFIG_CHECK="~INPUT_UINPUT"
		WARNING_INPUT_UINPUT="Your kernel needs uinput for the hdaps module to perform better"
		# Why call this twice?
		linux-info_pkg_setup

		MODULE_NAMES="${MODULE_NAMES} hdaps(extra:)"
		BUILD_PARAMS="${BUILD_PARAMS} HDAPS=1"

		CONFIG_CHECK="~!SENSORS_HDAPS"
		ERROR_SENSORS_HDAPS="${P} with USE=hdaps conflicts with in-kernel HDAPS (CONFIG_SENSORS_HDAPS)"
		linux-info_pkg_setup
	fi
}

pkg_pretend() {
	tp_smapi_pkg_pretend
}

pkg_setup() {
	# run again as pkg_pretend is not var safe
	tp_smapi_pkg_pretend
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
	einstalldocs
	newinitd "${FILESDIR}/${PN}-0.40-initd" smapi
	newconfd "${FILESDIR}/${PN}-0.40-confd" smapi
}
