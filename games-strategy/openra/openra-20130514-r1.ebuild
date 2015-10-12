# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils mono-env gnome2-utils vcs-snapshot games

DESCRIPTION="A free RTS engine supporting games like Command & Conquer and Red Alert"
HOMEPAGE="http://open-ra.org/"
SRC_URI="https://github.com/OpenRA/OpenRA/tarball/release-${PV} -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="cg tools"

DEPEND="dev-dotnet/libgdiplus
	dev-lang/mono
	media-libs/freetype:2[X]
	media-libs/libsdl[X,opengl,video]
	media-libs/openal
	virtual/jpeg
	virtual/opengl
	cg? ( >=media-gfx/nvidia-cg-toolkit-2.1.0017 )"
RDEPEND="${DEPEND}"

pkg_setup() {
	mono-env_pkg_setup
	games_pkg_setup
}

src_unpack() {
	vcs-snapshot_src_unpack
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch

	# register game-version
	sed \
		-e "/Version/s/{DEV_VERSION}/release-${PV}/" \
		-i mods/{ra,cnc,d2k}/mod.yaml || die
}

src_compile() {
	emake $(usex tools "all" "")
}

src_install() {
	emake \
		datadir="${GAMES_DATADIR}" \
		bindir="${GAMES_BINDIR}" \
		libdir="$(games_get_libdir)/${PN}" \
		DESTDIR="${D}" \
		$(usex tools "install-all" "install")

	# icons
	insinto /usr/share/icons/
	doins -r packaging/linux/hicolor

	# desktop entries
	local myrenderer=$(usex cg Cg Gl)
	make_desktop_entry "${PN} Game.Mods=cnc Graphics.Renderer=${myrenderer}" \
		"OpenRA CNC" ${PN}
	make_desktop_entry "${PN} Game.Mods=ra Graphics.Renderer=${myrenderer}" \
		"OpenRA RA" ${PN}
	make_desktop_entry "${PN} Game.Mods=d2k Graphics.Renderer=${myrenderer}" \
		"OpenRA Dune2k" ${PN}
	make_desktop_entry "${PN}-editor" "OpenRA Map Editor" ${PN}

	dodoc "${FILESDIR}"/README.gentoo README.md HACKING CHANGELOG

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

	if ! use cg ; then
		elog "If you have problems starting the game consider switching"
		elog "to Graphics.Renderer=Cg in openra*.desktop or manually"
		elog "run:"
		elog "${PN} Game.Mods=\$mod Graphics.Renderer=Cg"
	fi
}

pkg_postrm() {
	gnome2_icon_cache_update
}
