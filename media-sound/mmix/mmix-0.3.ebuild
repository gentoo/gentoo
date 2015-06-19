# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mmix/mmix-0.3.ebuild,v 1.1 2012/01/16 18:26:39 ssuominen Exp $

EAPI=4
inherit toolchain-funcs

DESCRIPTION="A soundcard mixer for the OSS driver"
HOMEPAGE="http://www.mcmilk.de/projects/mmix/"
SRC_URI="http://www.mcmilk.de/projects/${PN}/dl/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="virtual/os-headers"

src_prepare() {
	sed -i -e '/strip/d' Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} -Wall" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin ${PN}
	doman doc/${PN}.1
	dodoc doc/{AUTHORS,CHANGES,FAQ,README}
}
