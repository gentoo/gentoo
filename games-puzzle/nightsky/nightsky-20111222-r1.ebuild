# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="Puzzle game that puts you inside and ambient and mysterious universe"
HOMEPAGE="http://www.nicalis.com/nightsky/"
SRC_URI="nightskyhd-linux-1324519044.tar.gz"
S="${WORKDIR}/NightSky"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="bundled-libs"
RESTRICT="bindist fetch"

QA_PREBUILT="
	opt/${PN}/NightSky*
	opt/${PN}/lib/*
	opt/${PN}/lib64/*"

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
	rm -v NightSkyHD$(usev !amd64 _64) || die
	rm -rv lib$(usev !amd64 64) || die

	if ! use bundled-libs ; then
		einfo "Removing bundled libs..."
		rm -rv lib* || die
	fi

	# empty dir, we create symlink here later
	rm -r Settings || die

	sed "s|@GAMES_PREFIX_OPT@|${EPREFIX}/opt|" \
		"${FILESDIR}"/${PN}-wrapper > "${T}"/${PN} || die
}

src_install() {
	dobin "${T}"/${PN}

	insinto /opt/${PN}
	doins -r .

	newicon "World/The Void/Physical"/Circle72.png ${PN}.png
	make_desktop_entry ${PN} "NightSky HD"

	fperms +x /opt/${PN}/NightSkyHD$(usev amd64 _64)
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "Saves and Settings are in ~/.nightsky/Settings"
	fi
}
