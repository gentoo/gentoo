# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Fast-paced multiplayer deathmatch arcade game"
HOMEPAGE="https://github.com/keithfancher/Bomns-for-Linux"
SRC_URI="https://downloads.sourceforge.net/greenridge/${P}.tar.gz"

LICENSE="GPL-2+"
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
	"${FILESDIR}"/${P}-c23.patch
	"${FILESDIR}"/${P}-clang.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	filter-flags -fforce-addr
	econf \
		--disable-launcher1 \
		$(use_enable gtk launcher2) \
		$(use_enable editor)
}
