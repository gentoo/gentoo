# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils toolchain-funcs

DESCRIPTION="METAR Decoder Software Package Library"
HOMEPAGE="http://limulus.net/mdsplib/"
SRC_URI="http://limulus.net/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_compile() {
	tc-export AR CC RANLIB
	emake all || die "emake all failed"
}

src_install() {
	insinto /usr/include
	insopts -m0644
	doins metar.h || die "doins failed"
	dolib.a libmetar.a || die "dolib.a failed"
	dodoc README README.MDSP
	dobin dmetar || die "dobin failed"
}
