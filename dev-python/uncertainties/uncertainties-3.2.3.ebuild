# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="Python module for calculations with uncertainties"
HOMEPAGE="
	https://pythonhosted.org/uncertainties/
	https://github.com/lmfit/uncertainties/
	https://pypi.org/project/uncertainties/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

pkg_postinst() {
	optfeature "numpy support" dev-python/numpy
}
