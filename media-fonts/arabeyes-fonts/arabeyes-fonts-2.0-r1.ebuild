# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

MY_PN="ae_fonts"
S="${WORKDIR}"/${MY_PN}_${PV}

DESCRIPTION="Arabeyes Arabic TrueType fonts"
HOMEPAGE="https://www.arabeyes.org/Khotot#2.0"
SRC_URI="mirror://sourceforge/arabeyes/${MY_PN}_${PV}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 arm ia64 ppc s390 sh sparc x86"

FONT_SUFFIX="ttf"

DOCS="README ChangeLog"

src_install() {
	local d
	for d in AAHS AGA FS Kasr MCS Shmookh; do
		FONT_S="${S}"/$d
		font_src_install
	done
}
