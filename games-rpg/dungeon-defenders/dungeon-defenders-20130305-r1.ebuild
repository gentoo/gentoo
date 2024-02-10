# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs desktop unpacker wrapper xdg

TIMESTAMP="${PV:4:2}${PV:6:2}${PV:0:4}"
DESCRIPTION="A hybrid of two hot genres: Tower Defense and cooperative online Action-RPG"
HOMEPAGE="https://www.humblebundle.com/store/dungeon-defenders-collection"
SRC_URI="dundef-linux-${TIMESTAMP}.mojo.run"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist fetch splitdebug"

BDEPEND="
	app-arch/unzip
"
RDEPEND="
	media-libs/libsdl2[abi_x86_32,opengl,video]
	media-libs/openal[abi_x86_32]
	virtual/opengl[abi_x86_32]
	x11-misc/xdg-utils
"

DIR="/opt/${PN}"
QA_PREBUILT="${DIR#/}/*"

CHECKREQS_DISK_BUILD="5916M"
S="${WORKDIR}/data"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to your distfiles directory."
}

src_unpack() {
	unpack_zip ${A}
}

src_prepare() {
	default

	# https://bugzilla.icculus.org/show_bug.cgi?id=5894
	sed -i 's/LobbyLevel_Valentines2013\.udk/LobbyLevel.udk/' UDKGame/Config/DefaultDunDef.ini || die

	# Remove bundled binaries.
	rm -v UDKGame/Binaries/{*.so*,xdg-open} || die
}

src_install() {
	# Move the data rather than copying. The game consumes over 5GB so a
	# needless copy should really be avoided!
	dodir "${DIR}"
	mv -v Engine/ UDKGame/ "${ED}${DIR}" || die

	# Use system xdg-open script, location is hardcoded.
	dosym ../../../../usr/bin/xdg-open "${DIR}"/UDKGame/Binaries/xdg-open

	make_wrapper ${PN} ./DungeonDefenders-x86 "${DIR}"/UDKGame/Binaries
	newicon -s 48 DunDefIcon.png ${PN}.png
	make_desktop_entry ${PN} "Dungeon Defenders"

	dodoc README-linux.txt
}
