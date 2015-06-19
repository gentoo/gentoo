# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/duke3d-demodata/duke3d-demodata-1.3.ebuild,v 1.2 2014/06/01 20:21:54 hasufell Exp $

EAPI=5

inherit games

DESCRIPTION="Duke Nukem 3D 1.3d shareware data"
HOMEPAGE="http://www.3drealms.com/duke3d/"
SRC_URI="ftp://ftp.3drealms.com/share/3dduke13.zip"

LICENSE="DUKE3D"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="games-fps/eduke32"

S=${WORKDIR}

src_unpack() {
	default
	rm LICENSE.TXT || die
	mv DN3DSW13.SHR DN3DSW13.SHR.zip || die
	unpack ./DN3DSW13.SHR.zip
}

src_install() {
	insinto "${GAMES_DATADIR}"/duke3d

	# convert to lowercase
	find . \( -iname "*.CON" -o -iname "*.DMO" -o -iname "*.RTS" -o -iname "*.GRP" -o -iname "*.PCK" -o -iname "*.INI" \) \
		-exec sh -c 'echo "${1}"
	mv "${1}" "$(echo "${1}" | tr [:upper:] [:lower:])"' - {} \;

	doins {defs,game,user}.con demo{1,2,3}.dmo duke.rts duke3d.grp modem.pck ultramid.ini

	dodoc FILE_ID.DIZ README.DOC

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	echo
	einfo "Please note that many addons for Duke Nukem 3D require the registered version"
	einfo "and will not work with this shareware version."
	echo
}
