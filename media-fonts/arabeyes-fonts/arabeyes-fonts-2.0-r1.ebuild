# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="ae_fonts"
inherit font

DESCRIPTION="Arabeyes Arabic TrueType fonts"
HOMEPAGE="https://www.arabeyes.org/Khotot#2.0"
SRC_URI="mirror://sourceforge/arabeyes/${MY_PN}_${PV}.tar.bz2"
S="${WORKDIR}/${MY_PN}_${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~ia64 ~loong ppc ~ppc64 ~riscv ~s390 sparc x86"

DOCS=( README ChangeLog )

FONT_SUFFIX="ttf"

src_install() {
	local d
	for d in AAHS AGA FS Kasr MCS Shmookh; do
		FONT_S="${S}"/$d
		font_src_install
	done
}
