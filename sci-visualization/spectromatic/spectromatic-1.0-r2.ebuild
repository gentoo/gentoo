# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

MY_P=${PN}_${PV}-1

DESCRIPTION="Generates time-frequency analysis images from wav files"
HOMEPAGE="http://ieee.uow.edu.au/~daniel/software/spectromatic/"
SRC_URI="http://ieee.uow.edu.au/~daniel/software/spectromatic/dist/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	media-libs/libpng:0
	sci-libs/gsl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( README )

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-stringliteral.patch
	"${FILESDIR}"/${P}-waveheaderstruct-amd64.patch
)

pkg_setup() {
	tc-export CC
	export TOPLEVEL_HOME="${EROOT}/usr"
}

src_prepare() {
	epatch ${PATCHES[@]}
}
