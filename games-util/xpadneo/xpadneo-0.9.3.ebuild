# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# pkgcheck note: toolchain-funcs is not unused
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

S="${WORKDIR}/${P}/hid-${PN}"
MODULE_NAMES="hid-${PN}(kernel/drivers/hid::src)"
BUILD_PARAMS='V=1 LD="$(tc-getLD)" KERNEL_SOURCE_DIR="${KV_OUT_DIR}"'
BUILD_TARGETS="modules"

CONFIG_CHECK="INPUT_FF_MEMLESS"

src_install() {
	linux-mod_src_install

	insinto /etc/modprobe.d
	doins etc-modprobe.d/${PN}.conf

	udev_dorules etc-udev-rules.d/60-${PN}.rules

	dodoc -r ../docs/{[^i]*.md,descriptors,reports} ../NEWS.md
}

pkg_postinst() {
	linux-mod_pkg_postinst
	udev_reload

	local disable_ertm=/sys/module/bluetooth/parameters/disable_ertm
	if kernel_is -ge 5 12; then
		if [[ $(<${disable_ertm}) == Y ]]; then
			elog "Warning: bluetooth ERTM (Enhanced ReTransmission Mode) is disabled."
			elog "This is no longer recommended with kernel >=5.12 to use ${PN}."
			elog "Can remove ${EROOT}/etc/modprobe.d/no-ertm.conf if it exists, and run:"
			elog "  echo N > ${disable_ertm}"
			elog "After changing, may need to re-pair the gamepad with bluetooth."
		fi
	elif [[ $(<${disable_ertm}) == N ]]; then
		elog "Warning: bluetooth ERTM (Enhanced ReTransmission Mode) is enabled."
		elog "While keeping enabled is recommended for rumble usage stability, it can"
		elog "cause connection issues without a fix included in kernel >=5.12"
		elog "If needed, this mode can be disabled by running:"
		elog "  echo Y > ${disable_ertm}"
		elog "  echo 'options bluetooth disable_ertm=y' > ${EROOT}/etc/modprobe.d/no-ertm.conf"
		elog "After changing, may need to re-pair the gamepad with bluetooth."
	fi

	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog "To pair the gamepad and view module options, see documentation in:"
		elog "  ${EROOT}/usr/share/doc/${PF}/"
	fi
}

pkg_postrm() {
	linux-mod_pkg_postrm
	udev_reload
}
