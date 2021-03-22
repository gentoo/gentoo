# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-mod toolchain-funcs udev

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/atar-axis/xpadneo.git"
	EGIT_MIN_CLONE_TYPE="single"
else
	SRC_URI="https://github.com/atar-axis/xpadneo/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Advanced Linux Driver for Xbox One Wireless Controller"
HOMEPAGE="https://atar-axis.github.io/xpadneo/"

LICENSE="GPL-3"
SLOT="0"

S+="/hid-${PN}"
MODULE_NAMES="hid-${PN}(kernel/drivers/hid::src)"
BUILD_PARAMS='V=1 LD="$(tc-getLD)" KERNEL_SOURCE_DIR="${KV_OUT_DIR}"'
BUILD_TARGETS="src/version.h modules"

CONFIG_CHECK="INPUT_FF_MEMLESS"

src_install() {
	linux-mod_src_install

	insinto /etc/modprobe.d
	doins etc-modprobe.d/${PN}.conf

	udev_dorules etc-udev-rules.d/98-${PN}.rules

	dodoc -r ../docs/{[^i]*.md,descriptors,reports} ../NEWS.md
}

pkg_postinst() {
	linux-mod_pkg_postinst
	udev_reload

	local ertm=/sys/module/bluetooth/parameters/disable_ertm
	if ! [[ ${REPLACING_VERSIONS} && $(<${ertm}) == Y ]]; then
		elog "To pair the gamepad and view module options, see documentation in:"
		elog "  ${EROOT}/usr/share/doc/${PF}"
		elog
		elog "Be warned that bluetooth's ERTM (Enhanced ReTransmission Mode) can"
		elog "cause the gamepad to enter a re-connection loop."
		elog "- To disable immediately:"
		elog "    echo Y > ${ertm}"
		elog "- To disable for next and subsequent boot:"
		elog "    echo 'options bluetooth disable_ertm=y' > ${EROOT}/etc/modprobe.d/no-ertm.conf"
		elog "- Or, if bluetooth isn't a module, add to the kernel's command line:"
		elog "    bluetooth.disable_ertm=y"
	fi
}

pkg_postrm() {
	linux-mod_pkg_postrm
	udev_reload
}
