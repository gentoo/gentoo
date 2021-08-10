# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake linux-info

DESCRIPTION="utility that shows an estimated instantaneous bandwidth on USB buses and devices"
HOMEPAGE="https://github.com/aguinet/usbtop"
SRC_URI="https://github.com/aguinet/usbtop/archive/release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-libs/libpcap:=[usb]
	dev-libs/boost:="
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-release-${PV}"

pkg_setup() {
	linux-info_pkg_setup
	if linux_config_exists; then
		CONFIG_CHECK="~USB_MON"
		check_extra_config
	fi
}
