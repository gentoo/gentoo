# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Python bindings for libdiscid"
HOMEPAGE="https://github.com/JonnyJD/python-discid"
SRC_URI="https://github.com/JonnyJD/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc"

RDEPEND=">=media-libs/libdiscid-0.2.2"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

python_prepare_all() {
	# Skip broken Sphinx extension
	# https://github.com/JonnyJD/python-discid/commit/fd714adc2d34b3b661b64cda53190b42a33d1670
	sed -i "s/, 'sphinx.ext.intersphinx'//;/ext.data_doc/d" doc/conf.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		cd doc || die
		sphinx-build . _build/html || die
		HTML_DOCS=( doc/_build/html/. )
	fi
}

python_test() {
	esetup.py test
}
