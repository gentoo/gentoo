# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

MY_P=${PN}_v${PV}

DESCRIPTION="Estimation of large phylogenies by maximum likelihood"
HOMEPAGE="http://atgc.lirmm.fr/phyml/"
SRC_URI="http://www.lirmm.fr/~guindon/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}"/${PN}-2.4.5-fix-build-system.patch )

src_prepare() {
	default
	tc-export CC
}

src_install() {
	dobin phyml
}
