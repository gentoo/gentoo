# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=(luajit)

inherit cmake lua-single xdg-utils

DESCRIPTION="Open-source engine for Heroes of Might and Magic III"
HOMEPAGE="https://vcmi.eu/"

INNO_SHA="96e9566a35fb51ebf13ffbdadfd49a93c1ae5c1a"
DISCORD_PRESENCE_SHA="52501e140db1c18d9da37dff9a9529bc4a9943c2"
SRC_URI="
	https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	launcher? (
		https://github.com/vcmi/innoextract/archive/${INNO_SHA}.tar.gz -> ${PN}-innoextract-${INNO_SHA}.tar.gz
	)
	discord? (
		https://github.com/EclipseMenu/discord-presence/archive/${DISCORD_PRESENCE_SHA}.tar.gz
		-> ${PN}-discord-presence-${DISCORD_PRESENCE_SHA}.tar.gz
	)
"
# N.B.: see here for correct commit of innoextract:
# https://github.com/vcmi/vcmi/tree/develop/launcher/lib

LICENSE="GPL-2+ discord? ( MIT ) launcher? ( ZLIB )"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+discord +editor erm +launcher lobby lua +translations +video"

REQUIRED_USE="
	erm? ( lua )
	lua? ( ${LUA_REQUIRED_USE} )
"

RDEPEND="
	dev-cpp/tbb:=
	dev-libs/boost:=[nls]
	dev-libs/fuzzylite:=
	media-libs/libsdl2:=[video]
	media-libs/libsquish:=
	media-libs/sdl2-image:=
	media-libs/sdl2-mixer:=
	media-libs/sdl2-ttf:=
	virtual/minizip:=
	virtual/zlib:=
	discord? ( dev-libs/libfmt:= )
	editor? (
		dev-qt/qtbase:6[gui,network,widgets,xml]
		dev-qt/qtsvg:6
	)
	launcher? (
		app-arch/xz-utils
		dev-libs/boost:=[bzip2,zlib]
		dev-qt/qtbase:6[gui,network,widgets]
	)
	lobby? ( dev-db/sqlite:3 )
	lua? ( ${LUA_DEPS} )
	video? ( media-video/ffmpeg:= )
"
	# app-arch/innoextract
	# XXX: vcmi wants it's own patched version to build extractor as library
DEPEND="
	${RDEPEND}
	discord? ( dev-cpp/glaze )
"
BDEPEND="
	virtual/pkgconfig
	launcher? ( translations? ( dev-qt/qttools:6[linguist] ) )
	editor? ( translations? ( dev-qt/qttools:6[linguist] ) )
"

src_unpack() {
	default

	if use launcher; then
		rmdir "${S}/launcher/lib/innoextract" || die
		mv "${WORKDIR}/innoextract-${INNO_SHA}" "${S}/launcher/lib/innoextract" || die
	fi

	if use discord; then
		rmdir "${S}/client/lib/discord-presence" || die
		mv "${WORKDIR}/discord-presence-${DISCORD_PRESENCE_SHA}" "${S}/client/lib/discord-presence" || die
	fi
}

src_prepare() {
	default

	# Avoid GCC ICE with -Wmismatched-tags
	sed -i -e '/-Wmismatched-tags/d' CMakeLists.txt || die
	# Use FindBoost
	sed -i -e 's/cmake_policy(SET CMP0167 NEW)/cmake_policy(SET CMP0167 OLD)/' CMakeLists.txt || die
	# Fix launcher linking
	sed -i -e '/target_link_libraries(vcmilauncher innoextract)/i\find_package(LibLZMA REQUIRED)' \
		-e 's/target_link_libraries(vcmilauncher innoextract)/target_link_libraries(vcmilauncher innoextract Boost::iostreams LibLZMA::LibLZMA)/' \
		launcher/CMakeLists.txt || die

	if use discord; then
		# Drop the CPM bootstrap.
		# It downloads deps fmt and glaze which are provided by deps.
		sed -i '/include(cmake\/CPM.cmake)/d' \
			client/lib/discord-presence/CMakeLists.txt || die
	fi

	cmake_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_DISCORD=$(usex discord)
		-DENABLE_EDITOR=$(usex editor)
		-DENABLE_ERM=$(usex erm)
		-DENABLE_LAUNCHER=$(usex launcher)
		-DENABLE_LOBBY=$(usex lobby)
		-DENABLE_LUA=$(usex lua)
		-DENABLE_TRANSLATIONS=$(usex translations)
		-DENABLE_VIDEO=$(usex video)

		-DENABLE_BATTLE_AI=ON
		-DENABLE_GITVERSION=OFF
		-DENABLE_MMAI=OFF
		-DENABLE_MONOLITHIC_INSTALL=OFF
		-DENABLE_NULLKILLER_AI=ON
		-DENABLE_NULLKILLER2_AI=ON
		-DENABLE_STUPID_AI=ON
		-DFORCE_BUNDLED_FL=OFF
		-DBoost_NO_BOOST_CMAKE=ON
	)

	cmake_src_configure
}

pkg_postinst() {
	elog 'For the game to work properly, please copy "Data", "Maps" and "Mp3"'
	elog "from Heroes III to \$HOME/.local/share/${PN}."
	elog "or use 'vcmibuilder' utility on your:"
	elog "   a) One or two CD's or CD images"
	elog "   b) gog.com installer"
	elog "   c) Directory with installed game"
	elog ""
	elog "For more information, please visit:"
	elog "https://github.com/vcmi/vcmi/blob/${PV}/docs/players/Installation_Linux.md"
	elog ""
	elog "Also, you may want to install VCMI Extras and Wake of Gods"
	elog "mods from the launcher after you start the game."

	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
