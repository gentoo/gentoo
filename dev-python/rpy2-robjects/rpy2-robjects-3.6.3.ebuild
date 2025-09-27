# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_REQ_USE="sqlite"
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="Python interface to the R language (embedded R)"
HOMEPAGE="
	https://rpy2.github.io/
	https://github.com/rpy2/rpy2/
	https://pypi.org/project/rpy2-robjects/
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	!<dev-python/rpy2-3.6.0
	>=dev-python/rpy2-rinterface-3.6.0[${PYTHON_USEDEP}]
	dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/tzlocal[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

pkg_postinst() {
	optfeature "ipython integration" dev-python/ipython
	optfeature "numpy integration" dev-python/numpy
	optfeature "pandas integration" dev-python/pandas
}
