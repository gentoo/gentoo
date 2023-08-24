# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake linux-info

DESCRIPTION="utility that shows an estimated instantaneous bandwidth on USB buses and devices"
HOMEPAGE="https://github.com/aguinet/usbtop"
#SRC_URI="https://github.com/aguinet/usbtop/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
COMMIT="b9a26bd22b91b84bd72906c6501e61df7b13f3d6"
SRC_URI="https://github.com/aguinet/usbtop/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"
IUSE=""

RDEPEND="net-libs/libpcap[usb]"
DEPEND="${RDEPEND}
	dev-libs/boost:="

#S="${WORKDIR}/${PN}-release-${PV}"
S="${WORKDIR}/${PN}-${COMMIT}"

pkg_setup() {
	linux-info_pkg_setup
	if linux_config_exists; then
		CONFIG_CHECK="~USB_MON"
		check_extra_config
	fi
}
