# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

S=${WORKDIR}/${P/_*/}

DESCRIPTION="Ninja IRC Client"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="ftp://qoop.org/ninja/stable/${P/_/}.tar.gz"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc ~ppc64 ~sparc x86"
IUSE="ncurses ipv6 ssl"

RESTRICT="test"

DEPEND="ncurses? ( sys-libs/ncurses )
	ssl?  ( dev-libs/openssl )"
RDEPEND="${DEPEND}"

MAKEOPTS="${MAKEOPTS} -j1"

src_configure() {
	econf $(use_enable ipv6)
}

src_install() {
	default
	mv "${ED}"/usr/bin/ninja{,_irc} || die #436804
}
