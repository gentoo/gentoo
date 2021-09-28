# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_REMOVE_MODULES_LIST=( FindLua{,51} )
LUA_COMPAT=( lua5-1 )
inherit cmake desktop flag-o-matic lua-single

MY_L10N=( de en it pl pt ru uk )

DESCRIPTION="Multi-player, 3D action role-playing game"
HOMEPAGE="https://sourceforge.net/projects/sumwars/"
SRC_URI="mirror://sourceforge/sumwars/${P/_/-}-src.tar.bz2"

LICENSE="GPL-3 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug tools ${MY_L10N[*]/#/l10n_}"
REQUIRED_USE="${LUA_REQUIRED_USE}"

DEPEND="
	${LUA_DEPS}
	dev-games/cegui[ogre,truetype]
	dev-games/ogre:=[freeimage,opengl]
	dev-games/ois
	dev-games/physfs
	dev-libs/tinyxml
	media-libs/freealut
	media-libs/libvorbis
	media-libs/openal
	net-libs/enet:1.3=
	x11-libs/libX11
	x11-libs/libXrandr
	tools? ( dev-libs/boost:= )"
RDEPEND="
	${DEPEND}
	media-libs/freeimage[jpeg,png]"

src_configure() {
	append-flags -fno-strict-aliasing

	local l langs=
	for l in "${MY_L10N[@]}"; do
		use l10n_${l} && langs+="${l} "
	done

	use debug && CMAKE_BUILD_TYPE=Debug

	local mycmakeargs=(
		-DLua_FIND_VERSION_MAJOR=$(ver_cut 1 $(lua_get_version))
		-DLua_FIND_VERSION_MINOR=$(ver_cut 2 $(lua_get_version))
		-DLua_FIND_VERSION_COUNT=2
		-DLua_FIND_VERSION_EXACT=ON
		-DSUMWARS_BUILD_TOOLS=$(usex tools)
		-DSUMWARS_DOC_DIR="${EPREFIX}"/usr/share/doc/${PF}
		-DSUMWARS_LANGUAGES="${langs:-en}"
		-DSUMWARS_NO_ENET=ON
		-DSUMWARS_NO_TINYXML=ON
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	newicon share/icon/SumWarsIcon_128x128.png ${PN}.png
	make_desktop_entry ${PN} "Summoning Wars"
}
