# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_P="${PN}-source-${PV}"
DESCRIPTION="Clone of BBS Door game Trade Wars 2002"
HOMEPAGE="http://twclone.sourceforge.net/"
SRC_URI="mirror://sourceforge/twclone/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}"/${P}-format.patch
)

src_install() {
	DOCS="AUTHORS ChangeLog PROTOCOL README TODO" \
		default
	cd "${D}/usr/bin"
	for f in * ; do
		mv {,${PN}-}${f}
	done
}
