# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit base

MY_P=${P/_/}
S=${WORKDIR}/${MY_P/rc*/}
DESCRIPTION="An ASCII Image Viewer"
SRC_URI="mirror://sourceforge/aa-project/${MY_P}.tar.gz"
HOMEPAGE="http://aa-project.sourceforge.net/aview/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=">=media-libs/aalib-1.4_rc4"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-filename-spaces.patch
	"${FILESDIR}"/${P}-tmp_creation.patch
	"${FILESDIR}"/${P}-includes.patch
)

src_compile() {
	econf || die
	make aview || die
}

src_install() {
	into /usr
	dobin aview asciiview

	doman *.1
	dodoc ANNOUNCE ChangeLog README TODO
}
