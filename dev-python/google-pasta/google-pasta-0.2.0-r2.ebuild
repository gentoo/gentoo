# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="AST-based Python refactoring library"
HOMEPAGE="
	https://github.com/google/pasta/
	https://pypi.org/project/google-pasta/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
