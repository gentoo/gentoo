# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils toolchain-funcs python udev

DESCRIPTION="Central Regulatory Domain Agent for wireless networks"
HOMEPAGE="https://wireless.kernel.org/en/developers/Regulatory"
SRC_URI="http://linuxwireless.org/download/crda/${P}.tar.bz2"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="dev-libs/openssl:0
	dev-libs/libnl:3
	net-wireless/wireless-regdb"
DEPEND="${RDEPEND}
	dev-python/m2crypto
	=dev-lang/python-2*
	virtual/pkgconfig"

src_prepare() {
	python_convert_shebangs 2 utils/key2pub.py

	epatch "${FILESDIR}"/${P}-missing-include.patch
	sed -i \
		-e "s:\<pkg-config\>:$(tc-getPKG_CONFIG):" \
		Makefile || die
}

src_compile() {
	emake \
		UDEV_RULE_DIR="$(get_udevdir)/rules.d" \
		REG_BIN=/usr/$(get_libdir)/crda/regulatory.bin \
		USE_OPENSSL=1 \
		CC="$(tc-getCC)" \
		all_noverify V=1
}

src_test() {
	emake USE_OPENSSL=1 CC="$(tc-getCC)" verify
}

src_install() {
	emake \
		UDEV_RULE_DIR="$(get_udevdir)/rules.d" \
		REG_BIN=/usr/$(get_libdir)/crda/regulatory.bin \
		USE_OPENSSL=1 \
		DESTDIR="${D}" \
		install

	keepdir /etc/wireless-regdb/pubkeys
}
