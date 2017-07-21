# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit toolchain-funcs multilib

DESCRIPTION="An irssi plugin providing Jabber/XMPP support"
HOMEPAGE="http://cybione.org/~irssi-xmpp/"
SRC_URI="http://cybione.org/~${PN}/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="<net-irc/irssi-1
	>=net-libs/loudmouth-1.4.0[debug]"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -e "s/{MAKE} doc-install/{MAKE}/" \
		-i Makefile || die #322355
	sed -e "/^CFLAGS\|LDFLAGS/ s/=/+=/" \
		-i config.mk || die
}

src_compile() {
	emake PREFIX=/usr CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr IRSSI_LIB=/usr/$(get_libdir)/irssi install
	dodoc README NEWS TODO docs/*
}
