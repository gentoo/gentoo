# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit linux-mod linux-info

COMMIT="9cf06524dfebda414675433141f771b36b7e68e8"

DESCRIPTION="Realtek 8192EU driver module for Linux kernel"
HOMEPAGE="https://github.com/Mange/rtl8192eu-linux-driver"
SRC_URI="https://github.com/Mange/rtl8192eu-linux-driver/archive/${COMMIT}.tar.gz -> rtl8192eu-${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

DEPEND="virtual/linux-sources"

S="${WORKDIR}/rtl8192eu-linux-driver-${COMMIT}"

MODULE_NAMES="8192eu(net/wireless)"
BUILD_TARGETS="all"

CONFIG_CHECK="!RTL8XXXU"
ERROR_RLT8XXXU="Module RTL8XXXU exists in the .config but shouldn't!"

src_unpack() {
	unpack ${A}
	cd "${S}"
}

pkg_setup() {
	linux-mod_pkg_setup
}

src_compile(){
	linux-mod_src_compile
}

src_install() {
	linux-mod_src_install
}

pkg_postinst() {
	linux-mod_pkg_postinst
}
