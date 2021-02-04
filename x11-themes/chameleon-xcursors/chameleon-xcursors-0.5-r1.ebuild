# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg

MY_PN="Chameleon"

DESCRIPTION="Style neutral scalable cursor theme"
HOMEPAGE="http://www.egregorion.net/2007/03/26/chameleon/"

COLOURS="Anthracite DarkSkyBlue SkyBlue Pearl White"
SRC_URI=""
for COLOUR in ${COLOURS} ; do
	SRC_URI="${SRC_URI} mirror://gentoo/${MY_PN}-${COLOUR}-${PV}.tar.bz2"
done

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"

src_install() {
	dodir /usr/share/cursors/xorg-x11/
	for COLOUR in ${COLOURS}; do
		for SIZE in Large Regular Small; do
			local name=${MY_PN}-${COLOUR}-${SIZE}
			cp -r "${WORKDIR}"/${name}-${PV} \
				"${ED}"/usr/share/cursors/xorg-x11/${name} || die
		done
	done
}
