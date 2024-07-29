# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop flag-o-matic

DESCRIPTION="Xjump clone with added features"
HOMEPAGE="https://jump.gnu.sinusoid.es/"
SRC_URI="mirror://gnu/gnujump/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libglvnd[X]
	media-libs/libsdl[opengl,sound,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	virtual/glu
	virtual/libintl"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-build/autoconf-archive
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-musl.patch
)

src_prepare() {
	default

	# change ac_unique_file given eautoreconf will move configure.in
	sed -i 's/(configure.in)//' configure.in || die

	# regenerate due to missing macros, ensure have autoconf-archive for GLU
	# and remove acinclude.m4 which does unnecessary checks (bug #818814)
	rm acinclude.m4 || die
	eautoreconf

	append-libs -lm #496924
}

src_install() {
	default

	newicon skins/xjump/hero1.0.png ${PN}.png
	make_desktop_entry ${PN} "GNUjump"
}
