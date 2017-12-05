# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="An irssi plugin providing Jabber/XMPP support"
HOMEPAGE="https://cybione.org/~irssi-xmpp/"
SRC_URI="https://github.com/cdidier/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=net-irc/irssi-0.8.13
	>=net-libs/loudmouth-1.4.0"

RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-irssi-1.0.patch" )

src_prepare() {
	default
	sed -e "s/{MAKE} doc-install/{MAKE}/" \
		-i Makefile || die #322355
}

src_compile() {
	emake PREFIX=/usr CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr IRSSI_LIB=/usr/$(get_libdir)/irssi install
	dodoc README NEWS TODO docs/*
}
