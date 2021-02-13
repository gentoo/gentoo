# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLOCALES="cs de en es fr it nl pt ru uk"
PLOCALE_BACKUP="en"
LUA_COMPAT=( lua5-1 luajit )

inherit cmake lua-single l10n

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/instead-hub/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/instead-hub/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="INSTEAD text-based quest game engine"
HOMEPAGE="https://instead.hugeping.ru/"

LICENSE="MIT"
SLOT="0"
IUSE="doc +iconv +sdl2"
# gtk3 is forced since gtk2 already near its end-of-life
# harfbuzz support requres features from SDL2_ttf version which is not yet released (>2.0.15)

REQUIRED_USE="
	${LUA_REQUIRED_USE}
"

BDEPEND="
	virtual/pkgconfig
	${LUA_DEPS}
"

SDL_DEPS="
	media-libs/libsdl!VER![sound,video]
	media-libs/sdl!VER!-mixer
	media-libs/sdl!VER!-image
	media-libs/sdl!VER!-ttf
"

COMMON_DEPEND="
	${LUA_DEPS}
	sys-libs/zlib
	x11-libs/gtk+:3
	sdl2? ( ${SDL_DEPS//!VER!/2} )
	!sdl2? ( ${SDL_DEPS//!VER!/} )
	iconv? ( >=virtual/libiconv-0-r1 )
"
# harfbuzz? (
# 		media-libs/harfbuzz 
#   	media-libs/sdl!VER!-ttf[harfbuzz]
#	)

RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

DOCS=( AUTHORS ChangeLog README.md )

src_prepare() {
	l10n_find_plocales_changes "${S}/lang" "" ".ini"

	rm_loc() { rm "lang/$1.ini" || die; }
	l10n_for_each_disabled_locale_do rm_loc

	# The docs dir contains some code to build pdf out of the Markdown docs, but it requires some
	# weird util called multimarkdown, so we will just install the md's themselfs.
	if use doc; then
		EXTRA_DOCS=()
		for l in $(l10n_get_locales) ${PLOCALE_BACKUP}; do
			for d in "docs/modules-$l.md" "docs/stead3-$l.md"; do
				if [[ -f "$d" ]]; then
					EXTRA_DOCS=( "${EXTRA_DOCS[@]}" "$d" )
				fi
			done
		done

		DOCS=( "${DOCS[@]}" "${EXTRA_DOCS[@]}" )
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWITH_GTK2=OFF
		-DWITH_GTK3=ON
		-DWITH_LUAJIT="$(usex lua_single_target_luajit)"
		-DWITH_ICONV="$(usex iconv)"
		-DWITH_SDL2="$(usex sdl2)"
	)
#		-DWITH_HARFBUZZ="$(usex harfbuzz)"

	cmake_src_configure
}

pkg_postinst() {
	elog "The instead package contains only a game engine. The actual"
	elog "games have to be installed separately. To install a game"
	elog "download an archive and extract it to ~/.instead/games or"
	elog "to ${EPREFIX}/usr/share/instead/games."
	elog ""
	elog "A collection of various games can be found at:"
	elog "  https://instead.itch.io/"
	elog "  http://instead-games.ru/"
	elog ""
	elog "Also there are some third-party tools to manage download"
	elog "and installation of games like insteadman3:"
	elog "  https://jhekasoft.github.io/insteadman"

}
