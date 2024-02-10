# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="A docutils backend for pybtex"
HOMEPAGE="
	https://github.com/mcmtroffaes/pybtex-docutils/
	https://pypi.org/project/pybtex-docutils/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/docutils-0.14[${PYTHON_USEDEP}]
	>=dev-python/pybtex-0.16[${PYTHON_USEDEP}]

"

distutils_enable_tests pytest
distutils_enable_sphinx doc
