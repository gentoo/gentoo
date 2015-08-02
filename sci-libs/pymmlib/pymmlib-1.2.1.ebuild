# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/pymmlib/pymmlib-1.2.1.ebuild,v 1.5 2015/08/02 18:53:20 ago Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 multilib

DESCRIPTION="Toolkit and library for the analysis and manipulation of macromolecular structural models"
HOMEPAGE="http://pymmlib.sourceforge.net/"
SRC_URI="mirror://github/masci/mmLib/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pygtkglext[${PYTHON_USEDEP}]
	media-libs/freeglut
	virtual/glu
	virtual/opengl
	x11-libs/libXmu"
DEPEND="${RDEPEND}
	doc? ( dev-python/epydoc[${PYTHON_USEDEP}] )"

python_prepare_all() {
	rm mmLib/NumericCompat.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && esetup.py doc
}

python_install_all() {
	DOCS=( "${S}"/README.txt )
	use doc && HTML_DOCS=( "${S}"/doc/. )
	distutils-r1_python_install_all

	python_foreach_impl python_doscript "${S}"/applications/* "${S}"/examples/*.py
}
