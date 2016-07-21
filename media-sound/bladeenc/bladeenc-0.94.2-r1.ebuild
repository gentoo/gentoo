# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils

DESCRIPTION="An mp3 encoder"
SRC_URI="http://bladeenc.mp3.no/source/${P}-src-stable.tar.gz"
HOMEPAGE="http://bladeenc.mp3.no/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-secfix.diff
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README TODO
}
