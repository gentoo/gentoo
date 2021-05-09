# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit epatch gnustep-2

S=${WORKDIR}/TextEdit

DESCRIPTION="A text editor with font, color, and style capabilities for GNUstep"
HOMEPAGE="http://www.nongnu.org/backbone/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

KEYWORDS="amd64 ~ppc x86"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc47.patch
	epatch "${FILESDIR}"/${P}-nsinvalidargument.patch
}
