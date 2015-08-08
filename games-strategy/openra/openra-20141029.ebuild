# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils mono-env gnome2-utils vcs-snapshot games

DESCRIPTION="A free RTS engine supporting games like Command & Conquer and Red Alert"
HOMEPAGE="http://open-ra.org/"
SRC_URI="https://github.com/OpenRA/OpenRA/tarball/release-${PV} -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tools"

QA_PREBUILT="$(games_get_libdir)/openra/liblua*"

DEPEND="dev-dotnet/libgdiplus
	dev-lang/mono
	media-libs/freetype:2[X]
	media-libs/libsdl2[X,opengl,video]
	media-libs/openal
	virtual/jpeg
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
	sed \
		-e "/Version/s/{DEV_VERSION}/release-${PV}/" \
		-i mods/{ra,cnc,d2k}/mod.yaml || die
}

src_compile() {
	emake $(usex tools "all" "")
	emake native-dependencies
	emake docs
}

src_install() {
	emake \
		datadir="/usr/share" \
		bindir="${GAMES_BINDIR}" \
		libdir="$(games_get_libdir)" \
		DESTDIR="${D}" \
		$(usex tools "install-all" "install") install-linux-scripts

	exeinto "$(games_get_libdir)/openra"
	doexe Eluant.dll.config liblua$(usex amd64 "64" "32")*

	# icons
	insinto /usr/share/icons/
	doins -r packaging/linux/hicolor

	# desktop entries
	make_desktop_entry "${PN} Game.Mods=cnc" "OpenRA CNC" ${PN}
	make_desktop_entry "${PN} Game.Mods=ra" "OpenRA RA" ${PN}
	make_desktop_entry "${PN} Game.Mods=d2k" "OpenRA Dune2k" ${PN}
	make_desktop_entry "${PN}-editor" "OpenRA Map Editor" ${PN}

	dodoc "${FILESDIR}"/README.gentoo README.md CONTRIBUTING.md AUTHORS \
		DOCUMENTATION.md Lua-API.md

	# file permissions
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update

	elog "optional dependencies:"
	elog "  media-gfx/nvidia-cg-toolkit (fallback renderer if OpenGL fails)"
}

pkg_postrm() {
	gnome2_icon_cache_update
}
