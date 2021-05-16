# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_PN="Numbat"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="New user-friendly method built for automatic dX-tensor determination"
HOMEPAGE="http://www.nmr.chem.uu.nl/~christophe/numbat.html"
SRC_URI="http://comp-bio.anu.edu.au/private/downloads/Numbat/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="
	gnome-base/libglade:2.0
	sci-libs/gsl
	x11-libs/gtk+:2
"
RDEPEND="
	${DEPEND}
	sci-chemistry/molmol
	sci-chemistry/pymol
	sci-visualization/gnuplot
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
#	"${FILESDIR}"/${P}-glade.patch
	"${FILESDIR}"/${P}-gnuplot.patch
)

src_prepare() {
	default

	sed \
		-e '/COPYING/d' \
		-e "s:doc/numbat:share/doc/${PF}:g" \
		-i Makefile.am src/common.h || die

	rm missing || die

	emake distclean
	eautoreconf
}

src_install() {
	docompress -x /usr/share/doc/${PF}

	default
}
