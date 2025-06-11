# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Python JSONPath Next-Generation"
HOMEPAGE="
	https://github.com/h2non/jsonpath-ng/
	https://pypi.org/project/jsonpath-ng/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv x86"

RDEPEND="
	dev-python/ply[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/oslotest[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
