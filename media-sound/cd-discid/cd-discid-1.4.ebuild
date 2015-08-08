# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="returns the disc id for the cd in the cd-rom drive"
HOMEPAGE="https://github.com/taem/cd-discid"
SRC_URI="https://github.com/taem/${PN}/archive/upstream/1.4.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 x86"

S=${WORKDIR}/${PN}-upstream-${PV}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr STRIP=/bin/true install
	dodoc changelog README
}
