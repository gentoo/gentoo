# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/nightsky/nightsky-20111222.ebuild,v 1.6 2015/02/10 10:18:03 ago Exp $

EAPI=5

inherit eutils gnome2-utils games

DESCRIPTION="Puzzle game that puts you inside and ambient and mysterious universe"
HOMEPAGE="http://www.nicalis.com/nightsky/"
SRC_URI="nightskyhd-linux-1324519044.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="bundled-libs"
RESTRICT="bindist fetch splitdebug"

MYGAMEDIR=${GAMES_PREFIX_OPT}/${PN}
QA_PREBUILT="${MYGAMEDIR#/}/NightSky*
	${MYGAMEDIR#/}/lib/*
	${MYGAMEDIR#/}/lib64/*"

RDEPEND="
	virtual/glu
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXxf86vm
	!bundled-libs? (
		media-libs/freealut
		media-libs/freeglut
		media-libs/libogg
		media-libs/libvorbis
		media-libs/openal
		sys-libs/zlib
	)"

S=${WORKDIR}/NightSky

pkg_nofetch() {
	einfo "Please buy & download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to ${DISTDIR}"
}

src_prepare() {
	einfo "removing ${ARCH} unrelated files..."
	rm -v NightSkyHD$(usex amd64 "" "_64") || die
	rm -rv lib$(usex amd64 "" "64") || die

	if ! use bundled-libs ; then
		einfo "removing bundled libs..."
		rm -rv lib* || die
	fi

	# empty dir, we create symlink here later
	rm -r Settings || die

	sed \
		-e "s#@GAMES_PREFIX_OPT@#${GAMES_PREFIX_OPT}#" \
		"${FILESDIR}"/${PN}-wrapper > "${T}"/${PN} || die
}

src_install() {
	dogamesbin "${T}"/${PN}

	insinto "${MYGAMEDIR}"
	doins -r *

	newicon -s 128 "World/The Void/Physical"/Circle72.png ${PN}.png
	make_desktop_entry ${PN}

	fperms +x "${MYGAMEDIR}"/NightSkyHD$(usex amd64 "_64" "")
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update

	echo
	elog "Saves and Settings are in ~/.nightsky/Settings"
	echo
}

pkg_postrm() {
	gnome2_icon_cache_update
}
