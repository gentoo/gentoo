# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit multilib python-single-r1

DESCRIPTION="Gnuplot like graphing program publication-quality figures"
HOMEPAGE="http://www.pyxplot.org.uk/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	app-text/gv
	dev-libs/libxml2:2
	media-libs/libpng:0=
	sci-libs/cfitsio
	sci-libs/fftw:3.0=
	sci-libs/gsl
	sci-libs/scipy[${PYTHON_USEDEP}]
	virtual/latex-base
	virtual/imagemagick-tools
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	sed \
		-e "s:/usr/local:${EPREFIX}/usr/:" \
		-e "s:/lib/:/$(get_libdir)/:" \
		-e "s:/doc/${PN}:/doc/${PF}:" \
		-i Makefile.skel || die "sed Makefile.skel failed"
	sed -i -e 's/-ltermcap//' configure || die
}
