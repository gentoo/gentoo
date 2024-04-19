# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )
PYPI_PN="${PN/_/-}"
inherit pypi distutils-r1

DESCRIPTION="Runtime inspection utilities for typing module"
HOMEPAGE="
	https://pypi.org/project/typing_inspect/
	https://github.com/ilevkivskyi/typing_inspect
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	dev-python/mypy_extensions[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
