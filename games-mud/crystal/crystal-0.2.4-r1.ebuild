# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="The crystal MUD client"
HOMEPAGE="http://www.evilmagic.org/crystal/"
SRC_URI="http://www.evilmagic.org/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/openssl:0=
	sys-libs/ncurses:0=
	sys-libs/zlib
	virtual/libiconv"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-build.patch
)

src_prepare() {
	default

	# avoid colliding with xscreensaver (bug #281191)
	mv crystal.6 crystal-mud.6 || die
	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	econf --disable-scripting
}
