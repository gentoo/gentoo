# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1

DESCRIPTION="A fast, extensible Markdown parser in pure Python"
HOMEPAGE="
	https://github.com/miyuchina/mistletoe/
	https://pypi.org/project/mistletoe/
"
# pypi has incomplete test suite
SRC_URI="
	https://github.com/miyuchina/mistletoe/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

# NB: pygments is technically optional but we like syntax highlighting
RDEPEND="
	dev-python/pygments[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/parameterized[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
