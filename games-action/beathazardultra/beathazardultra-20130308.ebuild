# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# TODO: unbundle allegro[gtk...] (no multilib on amd64 and 5.0.9 soname)

EAPI=5
inherit eutils unpacker games

DESCRIPTION="Intense music-driven arcade shooter powered by your music"
HOMEPAGE="http://www.coldbeamgames.com/"
SRC_URI="beathazard-installer_03-08-13"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="bundled-libs"
RESTRICT="bindist fetch splitdebug"

MYGAMEDIR=${GAMES_PREFIX_OPT}/${PN}
QA_PREBUILT="${MYGAMEDIR#/}/BeatHazard_Linux2
	${MYGAMEDIR#/}/hge_lib/*"

DEPEND="app-arch/unzip"
RDEPEND="
	virtual/opengl
	amd64? (
		!bundled-libs? (
			>=media-libs/libpng-1.2.51:1.2[abi_x86_32(-)]
			>=virtual/jpeg-0-r2[abi_x86_32(-)]
		)
		>=x11-libs/gtk+-2.24.23:2[abi_x86_32(-)]
		>=virtual/opengl-7.0-r1[abi_x86_32(-)]
		>=x11-libs/libX11-1.6.2[abi_x86_32(-)]
		>=x11-libs/libXcursor-1.1.14[abi_x86_32(-)]
		>=x11-libs/libXinerama-1.1.3[abi_x86_32(-)]
		>=x11-libs/libXrandr-1.4.2[abi_x86_32(-)]
	)
	x86? (
		x11-libs/gtk+:2
		x11-libs/libX11
		x11-libs/libXcursor
		x11-libs/libXinerama
		x11-libs/libXrandr
		!bundled-libs? (
			media-libs/libpng:1.2
			virtual/jpeg
		)
	)"

S=${WORKDIR}/data

pkg_nofetch() {
	einfo "Please buy & download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to ${DISTDIR}"
	einfo
}

src_unpack() {
	unpack_zip ${A}
}

src_prepare() {
	if ! use bundled-libs ; then
		einfo "Removing bundled libs..."
		rm -v all/hge_lib/libjpeg.so* all/hge_lib/libpng12.so* || die
	fi
}

src_install() {
	insinto "${MYGAMEDIR}"
	doins -r all/*

	dodoc Linux.README

	newicon SmileLogo.png ${PN}.png
	make_desktop_entry ${PN}
	games_make_wrapper ${PN} "./BeatHazard_Linux2" "${MYGAMEDIR}" "${MYGAMEDIR}/hge_lib"

	fperms +x "${MYGAMEDIR}"/BeatHazard_Linux2
	prepgamesdirs
}
