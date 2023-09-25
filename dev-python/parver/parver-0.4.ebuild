# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Parse and manipulate version numbers"
HOMEPAGE="
	https://github.com/RazerM/parver/
	https://pypi.org/project/parver/
"
SRC_URI="
	https://github.com/RazerM/parver/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv x86"

RDEPEND="
	>=dev-python/Arpeggio-1.7[${PYTHON_USEDEP}]
	>=dev-python/attrs-19.2[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/pretend[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
