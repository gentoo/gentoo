# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# TODO: unbundle libsdl-2

EAPI=5

inherit eutils unpacker gnome2-utils games

TIMESTAMP=${PV:0:4}-${PV:4:2}-${PV:6:2}
DESCRIPTION="Unleash the power of Heavy Metal to reign down fire from the sky"
HOMEPAGE="https://www.ea.com/de/brutal-legend"
SRC_URI="BrutalLegend-Linux-${TIMESTAMP}-setup.bin"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="bindist fetch splitdebug"

MYGAMEDIR=${GAMES_PREFIX_OPT}/${PN}
QA_PREBUILT="${MYGAMEDIR#/}/lib/*
	${MYGAMEDIR#/}/Buddha.bin.x86"

RDEPEND="
	amd64? (
		>=sys-libs/zlib-1.2.8-r1[abi_x86_32(-)]
		>=virtual/glu-9.0-r1[abi_x86_32(-)]
		>=virtual/opengl-7.0-r1[abi_x86_32(-)]
		>=x11-libs/libX11-1.6.2[abi_x86_32(-)]
		>=x11-libs/libXau-1.0.7-r1[abi_x86_32(-)]
		>=x11-libs/libXdmcp-1.1.1-r1[abi_x86_32(-)]
		>=x11-libs/libXext-1.3.2[abi_x86_32(-)]
		>=x11-libs/libxcb-1.9.1[abi_x86_32(-)]
	)
	x86? (
		sys-libs/zlib
		virtual/glu
		virtual/opengl
		x11-libs/libX11
		x11-libs/libXau
		x11-libs/libXdmcp
		x11-libs/libXext
		x11-libs/libxcb

	)"
DEPEND="app-arch/unzip"

S=${WORKDIR}/data

pkg_nofetch() {
	einfo "Please buy & download ${SRC_URI} from:"
	einfo "  https://www.humblebundle.com/store"
	einfo "and move it to ${DISTDIR}"
}

src_unpack() {
	unpack_zip ${A}
}

src_install() {
	newicon -s 256 Buddha.png ${PN}.png
	games_make_wrapper ${PN} "./Buddha.bin.x86" "${MYGAMEDIR}" "${MYGAMEDIR}/lib"
	make_desktop_entry ${PN}

	dodir "${MYGAMEDIR}"
	# this is over 9000!!!! ...eh, 8GB data
	mv * "${D%/}/${MYGAMEDIR}" || die

	fperms +x "${MYGAMEDIR}/Buddha.bin.x86"
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
