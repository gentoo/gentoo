# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

MY_PN="${PN/%-ngs/ngs}"

DESCRIPTION="Python bindings for the MusicBrainz NGS and the Cover Art Archive webservices"
HOMEPAGE="https://github.com/alastair/python-musicbrainzngs"
SRC_URI="https://github.com/alastair/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_PN}${PV}.tar.gz"

LICENSE="BSD-2 ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples test"

S="${WORKDIR}/${MY_PN}-${PV}"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

python_prepare_all() {
	# Prevent un-needed d'loading
	sed -e "s/, 'sphinx.ext.intersphinx'//" -i docs/conf.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	use examples && local EXAMPLES=( examples )

	distutils-r1_python_install_all
}
