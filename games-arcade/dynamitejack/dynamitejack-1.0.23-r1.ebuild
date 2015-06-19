# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/dynamitejack/dynamitejack-1.0.23-r1.ebuild,v 1.4 2015/06/01 21:41:33 mr_bones_ Exp $

# TODO: icon

EAPI=5
inherit eutils games

DESCRIPTION="A stealth game with bombs in glorious 2D"
HOMEPAGE="http://www.galcon.com/dynamitejack/"
SRC_URI="${P}.tgz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
RESTRICT="bindist fetch splitdebug"

MYGAMEDIR=${GAMES_PREFIX_OPT}/${PN}
QA_PREBUILT="${MYGAMEDIR#/}/bin/*"

# linked to pulseaudio
RDEPEND="
	>=virtual/opengl-7.0-r1[abi_x86_32(-)]
	>=media-libs/alsa-lib-1.0.27.2[abi_x86_32(-)]
	>=media-libs/flac-1.2.1-r5[abi_x86_32(-)]
	>=media-libs/libogg-1.3.0[abi_x86_32(-)]
	>=media-libs/libsdl-1.2.15-r4[X,sound,joystick,opengl,video,abi_x86_32(-)]
	>=media-libs/libsndfile-1.0.25[abi_x86_32(-)]
	>=media-libs/libvorbis-1.3.3-r1[abi_x86_32(-)]
	>=media-sound/pulseaudio-2.1-r1[abi_x86_32(-)]
	>=virtual/glu-9.0-r1[abi_x86_32(-)]
	>=x11-libs/libICE-1.0.8-r1[abi_x86_32(-)]
	>=x11-libs/libSM-1.2.1-r1[abi_x86_32(-)]
	>=x11-libs/libX11-1.6.2[abi_x86_32(-)]
	>=x11-libs/libXau-1.0.7-r1[abi_x86_32(-)]
	>=x11-libs/libxcb-1.9.1[abi_x86_32(-)]
	>=x11-libs/libXdmcp-1.1.1-r1[abi_x86_32(-)]
	>=x11-libs/libXext-1.3.2[abi_x86_32(-)]
	>=x11-libs/libXi-1.7.2[abi_x86_32(-)]
	>=x11-libs/libXtst-1.2.1-r1[abi_x86_32(-)]"

S=${WORKDIR}/${PN}

pkg_nofetch() {
	einfo "Please buy & download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to ${DISTDIR}"
}

src_prepare() {
	rm run_me || die
	mv LINUX.txt "${T}"/ || die
}

src_install() {
	dodoc "${T}"/LINUX.txt

	insinto "${MYGAMEDIR}"
	doins -r *

	games_make_wrapper ${PN} "./main" "${MYGAMEDIR}/bin"
	make_desktop_entry ${PN}

	fperms +x "${MYGAMEDIR}"/bin/main
	prepgamesdirs
}
