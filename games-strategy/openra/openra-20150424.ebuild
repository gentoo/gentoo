# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils mono-env gnome2-utils fdo-mime vcs-snapshot games

DESCRIPTION="A free RTS engine supporting games like Command & Conquer and Red Alert"
HOMEPAGE="http://www.openra.net/"
SRC_URI="https://dev.gentoo.org/~hasufell/distfiles/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tools"

LUA_V=5.1.5
DEPEND="dev-dotnet/libgdiplus
	~dev-lang/lua-${LUA_V}:0
	dev-lang/mono
	media-libs/freetype:2
	media-libs/libsdl2[opengl,video]
	media-libs/openal
	virtual/opengl"
RDEPEND="${DEPEND}"

pkg_setup() {
	mono-env_pkg_setup
	games_pkg_setup
}

src_unpack() {
	vcs-snapshot_src_unpack
}

src_configure() { :; }

src_prepare() {
	# register game-version
	emake VERSION="${PV}" version
	sed \
		-e "s/@LIBLUA51@/liblua.so.${LUA_V}/" \
		thirdparty/Eluant.dll.config.in > Eluant.dll.config || die
}

src_compile() {
	emake VERSION="${PV}" $(usex tools "all" "")
	emake VERSION="${PV}" docs
}

src_install() {
	emake \
		datadir="/usr/share" \
		bindir="${GAMES_BINDIR}" \
		libdir="$(games_get_libdir)" \
		VERSION="${PV}" \
		DESTDIR="${D}" \
		$(usex tools "install-all" "install") install-linux-scripts install-linux-mime install-linux-icons

	exeinto "$(games_get_libdir)/openra"
	doexe Eluant.dll.config

	# desktop entries
	make_desktop_entry "${PN} Game.Mods=cnc" "OpenRA CNC" ${PN}
	make_desktop_entry "${PN} Game.Mods=ra" "OpenRA RA" ${PN}
	make_desktop_entry "${PN} Game.Mods=d2k" "OpenRA Dune2k" ${PN}
	make_desktop_entry "${PN}-editor" "OpenRA Map Editor" ${PN}

	dodoc "${FILESDIR}"/README.gentoo README.md CONTRIBUTING.md AUTHORS \
		DOCUMENTATION.md Lua-API.md

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
