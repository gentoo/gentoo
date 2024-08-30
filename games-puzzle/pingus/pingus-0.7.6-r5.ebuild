# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit desktop flag-o-matic python-any-r1 scons-utils toolchain-funcs xdg

DESCRIPTION="Free Lemmings clone"
HOMEPAGE="https://pingus.gitlab.io/"
SRC_URI="https://pingus.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-3+ GPL-2+ ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="opengl music"

RDEPEND="
	dev-libs/boost:=
	media-libs/libpng:=
	media-libs/libsdl[joystick,opengl?,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer
	music? ( media-libs/sdl-mixer[mod] )
	opengl? ( media-libs/libglvnd[X] )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-noopengl.patch
	"${FILESDIR}"/${P}-gcc47.patch
	"${FILESDIR}"/${P}-echo-e.patch
	"${FILESDIR}"/${P}-gcc7.patch
	"${FILESDIR}"/${P}-boost_signals2.patch
	"${FILESDIR}"/${P}-python3.patch
	"${FILESDIR}"/${P}-gcc13.patch
	"${FILESDIR}"/${P}-ar-detection.patch
)

src_compile() {
	strip-flags
	escons \
		AR="$(tc-getAR)" \
		CXX="$(tc-getCXX)" \
		CCFLAGS="${CXXFLAGS}" \
		LINKFLAGS="${LDFLAGS}" \
		with_opengl=$(usex opengl 1 0)
}

src_install() {
	emake install-exec install-data \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}"/usr
	doman doc/man/pingus.6
	doicon data/images/icons/pingus.svg
	make_desktop_entry ${PN} Pingus
	einstalldocs
}
