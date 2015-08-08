# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils gnome2-utils unpacker games

DESCRIPTION="Team-based competetive arena play"
HOMEPAGE="http://www.awesomenauts.com/"
SRC_URI="Awesomenauts-Linux-${PV//./-}.bin"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="bundled-libs"
RESTRICT="bindist fetch bundled-libs? ( splitdebug )"

MYGAMEDIR=${GAMES_PREFIX_OPT}/${PN}
QA_PREBUILT="${MYGAMEDIR#/}/Awesomenauts.bin.x86
	${MYGAMEDIR#/}/Settings.bin.x86
	${MYGAMEDIR#/}/lib/*"

RDEPEND="
	virtual/opengl
	virtual/glu
	amd64? (
		>=virtual/opengl-7.0-r1[abi_x86_32(-)]
		>=virtual/glu-9.0-r1[abi_x86_32(-)]
		>=media-libs/freetype-2.5.0.1[abi_x86_32(-)]
		>=x11-libs/libX11-1.6.2[abi_x86_32(-)]
		!bundled-libs? (
			>=media-libs/libtheora-1.1.1[abi_x86_32(-)]
			>=media-libs/libsdl-1.2.15-r4:0[X,opengl,video,abi_x86_32(-)]
			>=media-libs/openal-1.15.1[abi_x86_32(-)]
			>=media-libs/libogg-1.3.0[abi_x86_32(-)]
			>=media-libs/libvorbis-1.3.3-r1[abi_x86_32(-)]
			media-gfx/nvidia-cg-toolkit[multilib]
		)
	)
	x86? (
		media-libs/freetype
		x11-libs/libX11
		!bundled-libs? (
			media-gfx/nvidia-cg-toolkit
			media-libs/libogg
			media-libs/libsdl:0[X,opengl,video]
			media-libs/libtheora
			media-libs/libvorbis
			media-libs/openal
		)
	)"
DEPEND="app-arch/unzip"

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
	if use !bundled-libs ; then
		rm -rv lib || die
	fi
}

src_install() {
	insinto "${MYGAMEDIR}"
	doins -r *

	doicon -s 256 AwesomenautsIcon.png
	make_desktop_entry "${PN}" "Awesomenauts" "AwesomenautsIcon"
	games_make_wrapper "${PN}" "./Awesomenauts.bin.x86" "${MYGAMEDIR}" "${MYGAMEDIR}/lib"
	make_desktop_entry "${PN}-settings" "Awesomenauts (settings)" "AwesomenautsIcon"
	games_make_wrapper "${PN}-settings" "./Settings.bin.x86" "${MYGAMEDIR}" "${MYGAMEDIR}/lib"

	fperms +x "${MYGAMEDIR}"/{Awesomenauts,Settings}.bin.x86

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
