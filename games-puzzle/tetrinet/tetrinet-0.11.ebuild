# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils flag-o-matic toolchain-funcs games

DESCRIPTION="console based tetrinet inc. standalone server"
HOMEPAGE="http://tetrinet.or.cz/"
SRC_URI="http://tetrinet.or.cz/download/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="ipv6"

RDEPEND=">=sys-libs/ncurses-5:0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-no-ipv6.patch \
		"${FILESDIR}"/${P}-build.patch

	use ipv6 && append-cflags -DHAVE_IPV6
	tc-export PKG_CONFIG
}

src_install() {
	dogamesbin tetrinet tetrinet-server
	dodoc README TODO tetrinet.txt
	prepgamesdirs
}
