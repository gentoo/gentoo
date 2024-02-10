# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Calculates the time some text takes the average human to read"
HOMEPAGE="
	https://github.com/alanhamlett/readtime/
	https://pypi.org/project/readtime/
"
SRC_URI="
	https://github.com/alanhamlett/readtime/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv x86"

RDEPEND="
	>=dev-python/beautifulsoup4-4.0.1[${PYTHON_USEDEP}]
	>=dev-python/markdown2-2.4.3[${PYTHON_USEDEP}]
	>=dev-python/pyquery-1.2[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
