# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg

COLOURS=( "Anthracite" "DarkSkyBlue" "SkyBlue" "Pearl" "White" )
MY_PN="Chameleon"

DESCRIPTION="Style neutral scalable cursor theme"
HOMEPAGE="https://store.kde.org/p/999948/"
for COLOUR in "${COLOURS[@]}"; do
	SRC_URI="${SRC_URI} mirror://gentoo/${MY_PN}-${COLOUR}-${PV}.tar.bz2"
done
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

RDEPEND="x11-libs/libXcursor"

src_install() {
	dodir /usr/share/cursors/xorg-x11/

	for COLOUR in "${COLOURS[@]}"; do
		for SIZE in Large Regular Small; do
			local name="${MY_PN}-${COLOUR}-${SIZE}"
			rm "${WORKDIR}"/${name}-${PV}/{COPYRIGHT,LICENSE} || die
			insinto /usr/share/cursors/xorg-x11/${name}
			doins -r "${WORKDIR}"/${name}-${PV}
		done
	done
}
