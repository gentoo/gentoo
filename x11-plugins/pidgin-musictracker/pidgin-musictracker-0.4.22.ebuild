# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit autotools

DESCRIPTION="A Pidgin now playing plugin to publicise the songs you are listening to in your status message"
HOMEPAGE="https://code.google.com/p/pidgin-musictracker/"
SRC_URI="https://pidgin-musictracker.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug"

DEPEND=">=net-im/pidgin-2.0.0[gtk]
	>=dev-libs/dbus-glib-0.73
	dev-libs/libpcre
	>=sys-devel/gettext-0.17"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e "s/DOMAIN/PACKAGE/g" po/Makefile.in.in || die "sed failed"
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		--disable-werror
}

src_install() {
	emake install DESTDIR="${D}" || die "make install failure"
	dodoc AUTHORS ChangeLog INSTALL README THANKS || die "dodoc failed"
	find "${D}" -name "*.la" -delete || die "error cleaning la file."
}
