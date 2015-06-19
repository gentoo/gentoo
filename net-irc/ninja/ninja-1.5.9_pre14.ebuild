# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/ninja/ninja-1.5.9_pre14.ebuild,v 1.6 2012/12/30 23:51:12 ottxor Exp $

S=${WORKDIR}/${P/_*/}

DESCRIPTION="Ninja IRC Client"
HOMEPAGE="http://ninja.qoop.org/"
SRC_URI="ftp://qoop.org/ninja/stable/${P/_/}.tar.gz"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc ~ppc64 ~sparc x86"
IUSE="ncurses ipv6 ssl"

RESTRICT="test"

DEPEND="ncurses? ( sys-libs/ncurses )
	ssl?  ( dev-libs/openssl )
	!dev-util/ninja" #436804
RDEPEND="${DEPEND}"

MAKEOPTS="${MAKEOPTS} -j1"

src_compile() {
	econf $(use_enable ipv6) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
