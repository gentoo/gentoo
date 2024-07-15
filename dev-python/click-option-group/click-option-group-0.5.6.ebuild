# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Click-extension package that adds option groups missing in Click"
HOMEPAGE="
	https://github.com/click-contrib/click-option-group
	https://pypi.org/project/click-option-group/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
