# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_REQ_USE="sqlite"
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi optfeature

DESCRIPTION="Python interface to the R language"
HOMEPAGE="
	https://rpy2.github.io/
	https://github.com/rpy2/rpy2
	https://pypi.org/project/rpy/
"
SRC_URI="$(pypi_sdist_url rpy2)"
S="${WORKDIR}/rpy2-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-lang/R-4.0
	dev-python/cffi[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/tzlocal[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

pkg_postinst() {
	optfeature "ipython integration" dev-python/ipython
	optfeature "numpy integration" dev-python/numpy
	optfeature "pandas integration" dev-python/pandas
}
