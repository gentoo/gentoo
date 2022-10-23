# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1 optfeature

DESCRIPTION="Python module for calculations with uncertainties"
HOMEPAGE="https://pythonhosted.org/uncertainties/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-python/future[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}
	test? (	dev-python/numpy[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest
distutils_enable_sphinx doc --no-autodoc

pkg_postinst() {
	optfeature "numpy support" dev-python/numpy
}
