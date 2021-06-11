# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} luajit )

inherit lua-single xdg-utils

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

REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="sys-libs/zlib
	${LUA_DEPS}
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
	econf --with-lua=$(usex lua_single_target_luajit luajit lua) \
		--with-luaversion=$(ver_cut 1-2 $(lua_get_version))
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die

	if [[ ${SLOT} != 0 ]]; then
		mv "${ED}/usr/bin/${PN}" "${ED}/usr/bin/${PN}-${SLOT}" || die
		mv "${ED}"/usr/share/applications/love{,"-$SLOT"}.desktop || die
		sed -i -e "/^Name=/s/$/ ($SLOT)/" -e "s|/usr/bin/love|/usr/bin/love-$SLOT|" "${ED}/usr/share/applications/love-$SLOT.desktop" || die
		rm -r "${ED}"/usr/{lib64/liblove.so,share/{mime/,pixmaps/,icons/,man/}} || die
	fi
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
