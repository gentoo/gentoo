# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg-utils

MY_P=${P/tex/TeX}-src

DESCRIPTION="Wysiwyg text processor with high-quality maths"
HOMEPAGE="https://www.texmacs.org/"
SRC_URI="https://www.texmacs.org/Download/ftp/tmftp/source/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE="debug jpeg netpbm sqlite svg spell"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	app-text/ghostscript-gpl
	<dev-scheme/guile-1.9[debug?,deprecated]
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

S="${WORKDIR}/${MY_P}"

src_configure() {
	local mycmakeargs=(
		-DUSE_SQLITE3=$(usex sqlite 1 0)
		-DDEBUG_ASSERT=$(usex debug 1 0)
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}
