# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0-gtk3"
inherit cmake wxwidgets

DESCRIPTION="Modern editor for Doom-engine based games and source ports"
HOMEPAGE="https://slade.mancubus.net/"
SRC_URI="https://github.com/sirjuddington/${PN^^}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="fluidsynth timidity webkit"

DEPEND="
	app-arch/bzip2:=
	dev-lang/lua:0
	>=media-libs/dumb-2:=
	media-libs/freeimage[jpeg,png,tiff]
	media-libs/glew:0=
	media-libs/libsfml:=
	net-misc/curl
	sys-libs/zlib
	x11-libs/wxGTK:${WX_GTK_VER}[opengl,webkit?,X]
	fluidsynth? ( media-sound/fluidsynth:= )
"

RDEPEND="
	${DEPEND}
	timidity? ( media-sound/timidity++ )
"

BDEPEND="
	app-arch/p7zip
	virtual/pkgconfig
"

S="${WORKDIR}/${PN^^}-${PV}"

PATCHES=(
	"${FILESDIR}"/${P}-bundled-libs.patch
	"${FILESDIR}"/${P}-sfml-gtk3.patch
	"${FILESDIR}"/${P}-wxGLCanvas.patch
	"${FILESDIR}"/${P}-freetype-deps.patch
	"${FILESDIR}"/${P}-fluidsynth-driver.patch
)

src_prepare() {
	cmake_src_prepare

	# Delete bundled libraries just in case.
	rm -r src/External/{dumb,glew,lua}/ || die

}

src_configure() {
	local mycmakeargs=(
		-DNO_FLUIDSYNTH=$(usex fluidsynth OFF ON)
		-DNO_WEBVIEW=$(usex webkit OFF ON)
		-DUSE_SFML_RENDERWINDOW=ON
		-DWX_GTK3=ON
	)
	setup-wxwidgets
	cmake_src_configure
}
