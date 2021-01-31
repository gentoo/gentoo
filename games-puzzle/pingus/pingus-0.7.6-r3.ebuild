# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )

inherit desktop flag-o-matic python-any-r1 scons-utils toolchain-funcs xdg

DESCRIPTION="Free Lemmings clone"
HOMEPAGE="https://pingus.gitlab.io/"
SRC_URI="https://pingus.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="opengl music"

RDEPEND="
	media-libs/libsdl[joystick,opengl?,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer
	music? ( media-libs/sdl-mixer[mod] )
	opengl? ( virtual/opengl )
	media-libs/libpng:0=
	dev-libs/boost:=
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
)

src_prepare() {
	xdg_src_prepare
	strip-flags
}

src_compile() {
	escons \
		CXX="$(tc-getCXX)" \
		CCFLAGS="${CXXFLAGS}" \
		LINKFLAGS="${LDFLAGS}" \
		with_opengl=$(usex opengl 1 0)
}

src_install() {
	emake install-exec install-data \
		DESTDIR="${D}" \
		PREFIX="/usr"
	doman doc/man/pingus.6
	doicon data/images/icons/pingus.svg
	make_desktop_entry ${PN} Pingus
	einstalldocs
}
