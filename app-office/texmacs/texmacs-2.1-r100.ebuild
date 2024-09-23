# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 1-8 )
GUILE_REQ_USE="debug?,deprecated"
inherit cmake xdg guile-single

MY_P=${P/tex/TeX}-src

DESCRIPTION="Wysiwyg text processor with high-quality maths"
HOMEPAGE="https://www.texmacs.org/"
SRC_URI="https://www.texmacs.org/Download/ftp/tmftp/source/${MY_P}.tar.gz"

S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="debug jpeg netpbm sqlite svg spell"
REQUIRED_USE="${GUILE_REQUIRED_USE}"

RDEPEND="
	${GUILE_DEPS}
	app-text/ghostscript-gpl
	media-libs/freetype
	x11-apps/xmodmap
	x11-libs/libXext
	virtual/latex-base
	>=dev-qt/qtcore-5.9.1:5
	>=dev-qt/qtgui-5.9.1:5
	>=dev-qt/qtwidgets-5.9.1:5
	>=dev-qt/qtprintsupport-5.9.1:5
	sqlite? ( dev-db/sqlite )
	jpeg? ( virtual/imagemagick-tools[jpeg] )
	netpbm? ( media-libs/netpbm )
	spell? ( app-text/aspell )
	svg? ( || ( media-gfx/inkscape gnome-base/librsvg:2 ) )
"
DEPEND="${RDEPEND}"
BDEPEND="x11-base/xorg-proto"

src_prepare() {
	cmake_src_prepare
	guile_bump_sources
}

src_configure() {
	local mycmakeargs=(
		-DUSE_SQLITE3=$(usex sqlite 1 0)
		-DDEBUG_ASSERT=$(usex debug 1 0)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	# guile-single_src_install not needed, Guile 1.8 does not have .go
	# files...
}
