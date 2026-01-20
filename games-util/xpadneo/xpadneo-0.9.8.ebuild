# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1 udev

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/atar-axis/xpadneo.git"
	EGIT_MIN_CLONE_TYPE="single"
else
	SRC_URI="https://github.com/atar-axis/xpadneo/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~x86"
fi

DESCRIPTION="Advanced Linux Driver for Xbox One Wireless Controller"
HOMEPAGE="https://atar-axis.github.io/xpadneo/"

LICENSE="GPL-3"
SLOT="0"

CONFIG_CHECK="INPUT_FF_MEMLESS"

src_compile() {
	local modlist=( hid-${PN}=kernel/drivers/hid:hid-${PN}:hid-${PN}/src )
	local modargs=( KERNEL_SOURCE_DIR="${KV_OUT_DIR}" )

	linux-mod-r1_src_compile
}

src_install() {
	local DOCS=( docs/{[^i]*.md,descriptors,reports} NEWS.md )
	linux-mod-r1_src_install

	insinto /etc/modprobe.d
	doins hid-${PN}/etc-modprobe.d/${PN}.conf

	udev_dorules hid-${PN}/etc-udev-rules.d/*.rules
}

pkg_postinst() {
	linux-mod-r1_pkg_postinst
	udev_reload

	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog "To pair the gamepad and view module options, see documentation in:"
		elog "  ${EROOT}/usr/share/doc/${PF}/"
	fi
}

pkg_postrm() {
	udev_reload
}
