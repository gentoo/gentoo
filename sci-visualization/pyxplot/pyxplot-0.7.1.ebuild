# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"
PYTHON_DEPEND="2"

inherit eutils python

DESCRIPTION="Gnuplot like graphing program publication-quality figures"
HOMEPAGE="http://www.pyxplot.org.uk/"
SRC_URI="http://www.pyxplot.org.uk/src/${PN}_${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="virtual/latex-base
	sci-libs/scipy
	app-text/gv
	|| ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	sed -i \
		-e "s:^\(USRDIR=\).*:\1/usr:g" \
		-e "s:^\(SRCDIR=\).*:\1$(python_get_sitedir)/${PN}:g" \
		-e 's:^\(MANDIR=\).*:\1${USRDIR}/share/man/man1:g' \
		-e "s:^\(DOCDIR=\).*:\1\${USRDIR}/share/doc/${PF}:g" \
		-e '/install:/,$s:${\(SRC\|BIN\|DOC\|MAN\)DIR:${DESTDIR}/${\1DIR:g' \
		-e "/pyc/d" \
		-e 's/ex_\*/{ex_,fig}\*/' \
		Makefile.skel || die "sed Makefile.skel failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README AUTHORS ChangeLog
}
