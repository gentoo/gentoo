# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/pymmlib/pymmlib-1.2.0.ebuild,v 1.2 2012/05/14 13:29:29 jlec Exp $

EAPI=4

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit distutils multilib

DESCRIPTION="Toolkit and library for the analysis and manipulation of macromolecular structural models"
HOMEPAGE="http://pymmlib.sourceforge.net/"
SRC_URI="mirror://sourceforge/pymmlib/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="
	dev-python/numpy
	dev-python/pygtkglext
	media-libs/freeglut
	virtual/glu
	virtual/opengl
	x11-libs/libXmu"
DEPEND="${RDEPEND}
	doc? ( dev-python/epydoc )"

src_prepare() {
	rm mmLib/NumericCompat.py || die
	python_convert_shebangs $(python_get_version -f) "${S}"/applications/* "${S}"/examples/*.py
	distutils_src_prepare
}

src_compile() {
	distutils_src_compile

	if use doc; then
			$(PYTHON -f) setup.py doc || die
	fi
}

src_install() {
	distutils_src_install
	dobin "${S}"/applications/* "${S}"/examples/*.py
	dodoc "${S}"/README.txt
	dohtml -r "${S}"/doc
}
