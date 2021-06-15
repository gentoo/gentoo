# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="Scrolling, platform-jumping, key-collecting, ancient pyramid exploring game"
HOMEPAGE="http://abe.sourceforge.net/"
SRC_URI="mirror://sourceforge/abe/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libsdl[sound,video]
	media-libs/sdl-mixer[vorbis]
	x11-libs/libXi"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-settings.patch
	"${FILESDIR}"/${P}-doublefree.patch
	"${FILESDIR}"/${P}-format.patch
	"${FILESDIR}"/${P}-format-security.patch
)

src_prepare() {
	default

	sed -i '/^TR_CFLAGS/d;/^TR_CXXFLAGS/d' configure || die
}

src_configure() {
	tc-export CC CXX

	econf --with-data-dir="${EPREFIX}"/usr/share/${PN}
}

src_install() {
	dobin src/abe

	insinto /usr/share/${PN}
	doins -r images maps sounds

	make_desktop_entry abe "Abe's Amazing Adventure" applications-games

	einstalldocs
}
