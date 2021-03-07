# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A Pidgin now playing plugin to publicise the songs you are listening"
HOMEPAGE="https://code.google.com/p/pidgin-musictracker/"
SRC_URI="https://pidgin-musictracker.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug"

DEPEND="
	dev-libs/dbus-glib
	dev-libs/libpcre
	net-im/pidgin[gtk]"
RDEPEND="${DEPEND}"
BDEPEND="sys-devel/gettext"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

src_prepare() {
	default
	sed -i -e "s/DOMAIN/PACKAGE/g" po/Makefile.in.in || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		--disable-werror
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
