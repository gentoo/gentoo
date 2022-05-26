# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="A fast-paced multiplayer deathmatch arcade game"
HOMEPAGE="http://greenridge.sourceforge.net"
SRC_URI="mirror://sourceforge/greenridge/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk editor"

DEPEND="
	media-libs/libsdl[video]
	media-libs/sdl-mixer
	gtk? ( x11-libs/gtk+:2 )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-fpe.patch
)

src_prepare() {
	default

	sed -i \
		-e "/appicondir/s:\$(prefix):/usr:" \
		-e "/desktopdir/s:\$(prefix):/usr:" \
		$(find icons -name Makefile.am) \
		Makefile.am || die

	sed -i \
		-e "s:\$*[({]prefix[})]/share:/var/lib/:" \
		configure.in \
		graphics/Makefile.am \
		levels/Makefile.am \
		sounds/Makefile.am || die

	mv configure.{in,ac} || die

	eautoreconf
}

src_configure() {
	filter-flags -fforce-addr
	econf \
		--disable-launcher1 \
		$(use_enable gtk launcher2) \
		$(use_enable editor)
}
