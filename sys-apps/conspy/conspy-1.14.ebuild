# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="Remote control for Linux virtual consoles"
HOMEPAGE="http://conspy.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-1/${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	sys-libs/ncurses:0=
"
DEPEND="
	${RDEPEND}
"
PATCHES=(
	"${FILESDIR}"/${PN}-1.14-tinfo.patch
)
DOCS=(
	ChangeLog.txt README.txt ${PN}.html
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
}
