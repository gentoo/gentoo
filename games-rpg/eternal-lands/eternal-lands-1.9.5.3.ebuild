# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit desktop toolchain-funcs xdg

DESCRIPTION="A 3D fantasy MMORPG written in C and SDL"
HOMEPAGE="http://www.eternal-lands.com"
SRC_URI="https://github.com/raduprv/Eternal-Lands/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="eternal_lands"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="app-arch/unzip
	dev-libs/libxml2
	media-libs/cal3d[-16bit-indices]
	media-libs/freealut
	media-libs/libpng:0=
	media-libs/libsdl[X,opengl,video]
	media-libs/libvorbis
	media-libs/openal
	media-libs/sdl-image
	media-libs/sdl-net
	sys-libs/zlib[minizip]
	virtual/glu
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXext"
DEPEND="${RDEPEND}
	media-libs/glew"
BDEPEND="${DEPEND}
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)"

S="${WORKDIR}/Eternal-Lands-${PV}"

PATCHES=(
	"${FILESDIR}/${PN}-1.9.5.3-build.patch"
	"${FILESDIR}/${PN}-1.9.5.3-minizip.patch"
)

src_prepare() {
	default

	sed -i "s/FEATURES/EL_FEATURES/g" make.defaults || die
	sed -i "s/FEATURES/EL_FEATURES/g" Makefile.linux || die

	# Remove bundled minizip
	rm io/{crypt,ioapi,unzip,zip}.h || die
	rm io/{ioapi,unzip,zip}.c || die

	cp Makefile.linux Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)"
	use doc && emake docs
}

src_install() {
	dobin el.linux.bin
	newbin "${FILESDIR}"/el-wrapper el
	newicon -s 48 elc.png ${PN}.png
	make_desktop_entry el "Eternal Lands"

	dodoc CHANGES TODO
	use doc && dodoc -r docs/html/
}
