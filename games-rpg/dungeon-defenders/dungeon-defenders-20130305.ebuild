# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# TODO: unbundle SDL-2 when it gets released

EAPI=5
inherit check-reqs eutils gnome2-utils unpacker games

TIMESTAMP="${PV:4:2}${PV:6:2}${PV:0:4}"
MY_PN="DungeonDefenders"
DESCRIPTION="A hybrid of two hot genres: Tower Defense and cooperative online Action-RPG"
HOMEPAGE="http://dungeondefenders.com/"
SRC_URI="dundef-linux-${TIMESTAMP}.mojo.run"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="bundled-libs"
RESTRICT="bindist fetch splitdebug"

MYGAMEDIR=${GAMES_PREFIX_OPT}/${PN}
QA_PREBUILT="${MYGAMEDIR#/}/UDKGame/Binaries/${MY_PN}-x86
	${MYGAMEDIR#/}/UDKGame/Binaries/libSDL2-2.0.so.0"
CHECKREQS_DISK_BUILD="5916M"

# linked against pulseaudio
# without SDL-2 only linkage: opengl, openal
DEPEND="app-arch/unzip"
RDEPEND="
	x11-misc/xdg-utils
	>=media-libs/alsa-lib-1.0.27.2[abi_x86_32(-)]
	>=media-sound/pulseaudio-5.0[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXScrnSaver[abi_x86_32(-)]
	x11-libs/libXcursor[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]
	x11-libs/libXi[abi_x86_32(-)]
	x11-libs/libXinerama[abi_x86_32(-)]
	x11-libs/libXrandr[abi_x86_32(-)]
	x11-libs/libXxf86vm[abi_x86_32(-)]
	!bundled-libs? ( >=media-libs/openal-1.15.1[abi_x86_32(-)] )"

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
	# https://bugzilla.icculus.org/show_bug.cgi?id=5894
	sed -i \
		-e 's/LobbyLevel_Valentines2013.udk/LobbyLevel.udk/' \
		UDKGame/Config/DefaultDunDef.ini || die

	# Remove the binaries that we're unbundling and unnecessary stuff
	rm -v UDKGame/Binaries/xdg-open || die
	if ! use bundled-libs ; then
		einfo "Removing bundled libs..."
		rm -v UDKGame/Binaries/libopenal.so.1 || die
	fi
}

src_install() {
	# Move the data rather than copying. The game consumes over 5GB so
	# a needless copy should really be avoided!
	dodir "${MYGAMEDIR}"
	mv -v Engine UDKGame "${D}${MYGAMEDIR}" || die

	# use system xdg-open script, location is hardcoded
	dosym /usr/bin/xdg-open "${MYGAMEDIR}"/UDKGame/Binaries/xdg-open

	newicon -s 48 DunDefIcon.png ${PN}.png
	make_desktop_entry "${PN}" "Dungeon Defenders"
	games_make_wrapper ${PN} "./${MY_PN}-x86" "${MYGAMEDIR}/UDKGame/Binaries"

	dodoc README-linux.txt

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
