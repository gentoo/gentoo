# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="utility to test and create .sfv files and create .par files"
HOMEPAGE="http://pure-sfv.sourceforge.net/"
SRC_URI="mirror://sourceforge/pure-sfv/${PN}_${PV}_src.tar.gz"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc x86"
RESTRICT="test"

PATCHES=( "${FILESDIR}"/${PN}-0.3-fix-build-system.patch )

src_configure() {
	tc-export CC
}

src_install() {
	dobin pure-sfv
	newdoc ReadMe.txt README
}
