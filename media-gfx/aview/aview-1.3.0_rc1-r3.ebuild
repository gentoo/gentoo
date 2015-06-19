# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/aview/aview-1.3.0_rc1-r3.ebuild,v 1.2 2013/08/15 08:29:37 grobian Exp $

EAPI=4

inherit base

MY_P=${P/_/}
S=${WORKDIR}/${MY_P/rc*/}
DESCRIPTION="An ASCII Image Viewer"
SRC_URI="mirror://sourceforge/aa-project/${MY_P}.tar.gz"
HOMEPAGE="http://aa-project.sourceforge.net/aview/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-solaris"
IUSE=""

DEPEND=">=media-libs/aalib-1.4_rc4"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-asciiview.patch
	"${FILESDIR}"/${P}-includes.patch
)

src_prepare() {
	base_src_prepare

	sed -i -e 's:#include <malloc.h>:#include <stdlib.h>:g' "${S}"/*.c || die
}

src_compile() {
	make aview
}

src_install() {
	dobin aview asciiview

	doman *.1
	dodoc ANNOUNCE ChangeLog README TODO
}
