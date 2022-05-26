# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Extract code blocks from markdown"
HOMEPAGE="
	https://github.com/nschloe/pytest-codeblocks/
	https://pypi.org/project/pytest_codeblocks/
"
SRC_URI="
	https://github.com/nschloe/pytest-codeblocks/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	>=dev-python/pytest-7.0.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	epytest -p pytester
}
