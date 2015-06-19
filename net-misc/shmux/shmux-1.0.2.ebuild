# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/shmux/shmux-1.0.2.ebuild,v 1.7 2014/10/31 11:11:02 jer Exp $

EAPI="5"
inherit autotools eutils

DESCRIPTION="Program for executing the same command on many hosts in parallel"
HOMEPAGE="http://web.taranis.org/shmux/"
SRC_URI="http://web.taranis.org/${PN}/dist/${P}.tgz"

LICENSE="shmux"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="pcre"
RESTRICT="test"

RDEPEND="
	pcre? ( dev-libs/libpcre )
	sys-libs/ncurses
"
DEPEND="${RDEPEND}
	virtual/awk"

src_prepare() {
	epatch "${FILESDIR}"/${P}-tinfo.patch
	eautoreconf
}

src_configure() {
	econf $(use_with pcre)
}

src_install() {
	dobin src/shmux
	doman shmux.1
	dodoc CHANGES
}
