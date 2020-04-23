# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="An irssi plugin providing Jabber/XMPP support"
HOMEPAGE="https://cybione.org/~irssi-xmpp/"
SRC_URI="https://github.com/cdidier/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	net-irc/irssi
	net-libs/loudmouth
"

RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -e "s/{MAKE} doc-install/{MAKE}/" \
		-i Makefile || die #322355
}

src_compile() {
	emake PREFIX=/usr
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr IRSSI_LIB=/usr/$(get_libdir)/irssi install
	dodoc README.md NEWS TODO docs/*
}
