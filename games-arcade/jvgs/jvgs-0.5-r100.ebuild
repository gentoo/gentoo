# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-1 )

inherit cmake desktop lua-single

DESCRIPTION="An open-source platform game with a sketched and minimalistic look"
HOMEPAGE="http://jvgs.sourceforge.net/"
SRC_URI="mirror://sourceforge/jvgs/${P}-src.tar.gz"
S="${WORKDIR}/${P}-src"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="${LUA_DEPS}
	dev-libs/tinyxml[stl]
	media-libs/libsdl[video]
	media-libs/sdl-mixer[vorbis]
	media-libs/freetype:2
	sys-libs/zlib:=
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	virtual/opengl
	virtual/glu
"
DEPEND="${RDEPEND}"
BDEPEND="dev-lang/swig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.5-fix-build-system.patch
	"${FILESDIR}"/${PN}-0.5-unbundle-tinyxml.patch
)

src_prepare() {
	sed -i "s:main.lua:/usr/share/${PN}/&:" src/main.cpp || die

	# Make sure we don't use bundled copy
	rm -r src/tinyxml/ || die

	cmake_src_prepare
}

src_install() {
	dobin "${BUILD_DIR}"/src/${PN}

	insinto /usr/share/${PN}
	doins -r main.lua resources

	newicon resources/drawing.svg ${PN}.svg
	make_desktop_entry ${PN} ${PN}

	einstalldocs
}
