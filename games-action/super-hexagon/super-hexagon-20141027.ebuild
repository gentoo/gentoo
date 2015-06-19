# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/super-hexagon/super-hexagon-20141027.ebuild,v 1.3 2015/02/10 10:13:31 ago Exp $

# we use bundled glew, cause slotting 1.6 does not give us
# much benefit for one consumer

EAPI=5

inherit eutils unpacker games

DESCRIPTION="A minimal action game by Terry Cavanagh, with music by Chipzel"
HOMEPAGE="http://www.superhexagon.com/"
SRC_URI="superhexagon-${PV:4:4}${PV:0:4}-bin"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="bundled-libs"
RESTRICT="bindist fetch splitdebug"

MYGAMEDIR=${GAMES_PREFIX_OPT}/${PN}
QA_PREBUILT="${MYGAMEDIR#/}/x86/*
	${MYGAMEDIR#/}/x86_64/*"

DEPEND="app-arch/unzip"
RDEPEND="
	virtual/glu
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXxf86vm
	!bundled-libs? (
		media-libs/freeglut
		media-libs/libogg
		media-libs/libvorbis
		media-libs/openal
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
	einfo "removing ${ARCH} unrelated files"
	rm -r $(usex amd64 "x86" "x86_64") || die

	if ! use bundled-libs ; then
		einfo "removing bundled-libs..."
		cd $(usex amd64 "x86_64" "x86") || die
		rm libglut.so* libogg.so* libopenal.so* libstdc++.so* \
			libvorbis.so* libvorbisfile.so*
	fi
}

src_install() {
	local myarch=$(usex amd64 "x86_64" "x86")

	insinto "${MYGAMEDIR}"
	doins -r data ${myarch} SuperHexagon.png

	dodoc Linux.README

	newicon SuperHexagon.png ${PN}.png
	make_desktop_entry ${PN}
	games_make_wrapper ${PN} "./${myarch}/superhexagon.${myarch}" "${MYGAMEDIR}" "${MYGAMEDIR}/${myarch}"

	fperms +x "${MYGAMEDIR}/${myarch}/superhexagon.${myarch}"
	prepgamesdirs
}
