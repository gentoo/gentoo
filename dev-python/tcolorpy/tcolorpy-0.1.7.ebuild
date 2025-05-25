# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="tcolorpy is a Python library to apply true color for terminal text"
HOMEPAGE="
	https://github.com/thombashi/tcolorpy/
	https://pypi.org/project/colorpy/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

BDEPEND="
	>=dev-python/setuptools-scm-8[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
