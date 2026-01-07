# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/data-apis/array-api-compat
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Array API standard compatibility wrapper over NumPy and others"
HOMEPAGE="
	https://github.com/data-apis/array-api-compat/
	https://pypi.org/project/array-api-compat/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		>=dev-python/numpy-1.22[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# err, what?
	tests/test_vendoring.py
)
