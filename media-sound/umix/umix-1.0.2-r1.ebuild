# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="Program for adjusting soundcard volumes"
HOMEPAGE="http://umix.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="ncurses oss"

DEPEND="ncurses? ( >=sys-libs/ncurses-5.2:= )"
RDEPEND="
	${DEPEND}
"
PATCHES=(
	"${FILESDIR}"/${P}-tinfo.patch
)
DOCS=(
	AUTHORS ChangeLog NEWS README TODO
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf
	use ncurses || myconf="--disable-ncurses"
	use oss || myconf="${myconf} --disable-oss"
	econf ${myconf}
}
