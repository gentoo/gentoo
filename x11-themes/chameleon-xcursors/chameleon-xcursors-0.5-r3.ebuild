# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

RDEPEND="x11-libs/libXcursor"

src_install() {
	dodir /usr/share/icons/

	for COLOUR in "${COLOURS[@]}"; do
		for SIZE in Large Regular Small; do
			local name="${MY_PN}-${COLOUR}-${SIZE}"
			rm "${WORKDIR}"/${name}-${PV}/{COPYRIGHT,LICENSE} || die
			insinto /usr/share/icons/
			doins -r "${WORKDIR}"/${name}-${PV}
		done
	done
}
