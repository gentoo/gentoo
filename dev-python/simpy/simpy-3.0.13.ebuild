# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE="tk"

inherit distutils-r1

MY_P="${P/simpy/SimPy}"

DESCRIPTION="Object-oriented, process-based discrete-event simulation language"
HOMEPAGE="http://simpy.readthedocs.org/en/latest/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

distutils_enable_sphinx docs
distutils_enable_tests setup.py

python_install_all() {
	DOCS=( AUTHORS.rst CHANGES.rst README.rst )
	if use doc; then
		pushd docs > /dev/null || die
		PYTHONPATH=.. emake html && HTML_DOCS=( docs/_build/html/. docs/_build/doctrees/. )
		popd > /dev/null || die
	fi

	distutils-r1_python_install_all
}
