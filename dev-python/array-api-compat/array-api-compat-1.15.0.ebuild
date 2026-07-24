# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=meson-python
PYPI_VERIFY_REPO=https://github.com/data-apis/array-api-compat
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Array API standard compatibility wrapper over NumPy and others"
HOMEPAGE="
	https://github.com/data-apis/array-api-compat/
	https://pypi.org/project/array-api-compat/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86"

BDEPEND="
	test? (
		>=dev-python/numpy-1.22[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
