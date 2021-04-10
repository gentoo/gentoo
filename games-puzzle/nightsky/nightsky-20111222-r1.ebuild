# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop gnome2-utils

DESCRIPTION="Puzzle game that puts you inside and ambient and mysterious universe"
HOMEPAGE="http://www.nicalis.com/nightsky/"
SRC_URI="nightskyhd-linux-1324519044.tar.gz"
S="${WORKDIR}"/NightSky

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="bundled-libs"

RESTRICT="bindist fetch splitdebug"

MYGAMEDIR=opt/${PN}
QA_PREBUILT="
	${MYGAMEDIR#/}/NightSky*
	${MYGAMEDIR#/}/lib/*
	${MYGAMEDIR#/}/lib64/*
"

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

pkg_nofetch() {
	einfo "Please buy & download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to your DISTDIR directory."
}

src_prepare() {
	default

	einfo "Removing ${ARCH} unrelated files..."
	rm -v NightSkyHD$(usex amd64 "" "_64") || die
	rm -rv lib$(usex amd64 "" "64") || die

	if ! use bundled-libs ; then
		einfo "Removing bundled libs..."
		rm -rv lib* || die
	fi

	# empty dir, we create symlink here later
	rm -r Settings || die

	sed \
		-e "s#@GAMES_PREFIX_OPT@#/opt#" \
		"${FILESDIR}"/${PN}-wrapper > "${T}"/${PN} || die
}

src_install() {
	dobin "${T}"/${PN}

	insinto "${MYGAMEDIR}"
	doins -r *

	newicon -s 128 "World/The Void/Physical"/Circle72.png ${PN}.png
	make_desktop_entry ${PN}

	fperms +x "${MYGAMEDIR}"/NightSkyHD$(usex amd64 "_64" "")
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update

	echo
	elog "Saves and Settings are in ~/.nightsky/Settings"
	echo
}

pkg_postrm() {
	gnome2_icon_cache_update
}
