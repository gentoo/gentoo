# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

inherit flag-o-matic lua-single xdg-utils

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/love2d/${PN}.git"
else
	SRC_URI="https://github.com/love2d/${PN}/releases/download/${PV}/${P}-linux-src.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

DESCRIPTION="A framework for 2D games in Lua"
HOMEPAGE="https://love2d.org/"

LICENSE="ZLIB"
SLOT="0"
IUSE="gme"

REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="sys-libs/zlib
	${LUA_DEPS}
	media-libs/freetype
	media-libs/libmodplug
	media-libs/libsdl2[joystick,opengl]
	media-libs/libtheora
	media-libs/libvorbis
	media-libs/openal
	media-sound/mpg123
	virtual/opengl
	gme? ( media-libs/game-music-emu )"
DEPEND="${RDEPEND}"

DOCS=( "readme.md" "changes.txt" )

src_prepare() {
	default
	if [[ ${PV} == 9999* ]]; then
		./platform/unix/automagic || die
	fi
}

src_configure() {
	# Bug #858719
	append-flags -fno-strict-aliasing

	local myeconfargs=(
		$(use_enable gme)
		--with-lua=$(usex lua_single_target_luajit luajit lua)
		--with-luaversion=$(ver_cut 1-2 $(lua_get_version))
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
