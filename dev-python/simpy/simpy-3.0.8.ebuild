# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )
PYTHON_REQ_USE="tk"

inherit distutils-r1

MY_P="${P/simpy/SimPy}"

DESCRIPTION="Object-oriented, process-based discrete-event simulation language"
HOMEPAGE="http://simpy.readthedocs.org/en/latest/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc test"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

python_test() {
	py.test -vv || die
}

python_install_all() {
	DOCS=( AUTHORS.txt CHANGES.txt README.txt )
	if use doc; then
		pushd docs > /dev/null || die
		PYTHONPATH=.. emake html && HTML_DOCS=( docs/_build/html/. docs/_build/doctrees/. )
		popd > /dev/null || die
	fi

	distutils-r1_python_install_all
}
