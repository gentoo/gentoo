# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Make multi-threaded pytest test cases fail when they should"
HOMEPAGE="
	https://github.com/bjoluc/pytest-reraise/
	https://pypi.org/project/pytest-reraise/
"
# no tests in pypi sdist, v2.1.2
SRC_URI="
	https://github.com/bjoluc/pytest-reraise/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/pytest-4.6[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
