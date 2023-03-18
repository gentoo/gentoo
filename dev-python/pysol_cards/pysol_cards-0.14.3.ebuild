# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Deal PySol FreeCell cards"
HOMEPAGE="
	https://github.com/shlomif/pysol_cards/
	https://pypi.org/project/pysol-cards/
"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv x86"

RDEPEND="
	dev-python/random2[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
