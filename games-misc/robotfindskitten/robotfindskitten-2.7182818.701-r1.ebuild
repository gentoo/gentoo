# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

DESCRIPTION="Help robot find kitten"
HOMEPAGE="http://robotfindskitten.org/"
SRC_URI="mirror://sourceforge/rfk/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="sys-libs/ncurses:0"
RDEPEND=${DEPEND}

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
)

src_install() {
	DOCS="AUTHORS BUGS ChangeLog NEWS" \
		default
	insinto /usr/share/${PN}
	doins nki/vanilla.nki
}
