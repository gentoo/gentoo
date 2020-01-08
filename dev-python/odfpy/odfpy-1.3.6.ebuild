# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Classifier: Programming Language :: Python :: 2 :: Only
# py3 fails one test, pypy anpother.
# Notes on page of home repo reports support of python3.
PYTHON_COMPAT=( python{2_7,3_6,3_7} )

inherit distutils-r1

DESCRIPTION="Python API and tools to manipulate OpenDocument files"
HOMEPAGE="https://github.com/eea/odfpy https://pypi.org/project/odfpy/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

python_test() {
	pytest -v || die "Tests failed with ${EPYTHON}"
}

python_install_all() {
	if use examples; then
		docinto examples
		dodoc -r examples/.
	fi
	distutils-r1_python_install_all
}
