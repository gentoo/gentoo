# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2-utils xdg-utils

if [[ ${PV} == 9999* ]]; then
	inherit mercurial
	EHG_REPO_URI="https://bitbucket.org/rude/${PN}"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://www.bitbucket.org/rude/${PN}/downloads/${P}-linux-src.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

DESCRIPTION="A framework for 2D games in Lua"
HOMEPAGE="http://love2d.org/"

LICENSE="ZLIB"
SLOT="0"
IUSE="+luajit"

RDEPEND="sys-libs/zlib
	!luajit? ( dev-lang/lua:0[deprecated] )
	luajit? ( dev-lang/luajit:2 )
	media-libs/freetype
	media-libs/libmodplug
	media-libs/libsdl2[joystick,opengl]
	media-libs/libogg
	media-libs/libtheora
	media-libs/libvorbis
	media-libs/openal
	media-sound/mpg123
	virtual/opengl"
DEPEND="${RDEPEND}"

DOCS=( "readme.md" "changes.txt" )

src_prepare() {
	default
	if [[ ${PV} == 9999* ]]; then
		./platform/unix/automagic || die
	fi
}

src_configure() {
	econf --with-lua=$(usex luajit luajit lua)
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
