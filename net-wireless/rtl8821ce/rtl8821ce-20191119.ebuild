# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit linux-mod

COMMIT="27f98a55cc48b9a26e6eb4127976c8feb95867d8"

DESCRIPTION="Realtek RTL8821CE Driver module for Linux kernel"
HOMEPAGE="https://github.com/tomaspinho/rtl8821ce"
SRC_URI="https://github.com/tomaspinho/rtl8821ce/archive/${COMMIT}.tar.gz -> rtl8821ce-${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

DEPEND="virtual/linux-sources"

S="${WORKDIR}/rtl8821ce-${COMMIT}"

MODULE_NAMES="8821ce(net/wireless)"
BUILD_TARGETS="all"

src_unpack() {
	unpack ${A}
	cd "${S}"
}

src_prepare(){
	# fix 32bit build
	epatch "${FILESDIR}/32bit.patch"
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
