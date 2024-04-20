# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Extract code blocks from markdown"
HOMEPAGE="
	https://github.com/nschloe/pytest-codeblocks/
	https://pypi.org/project/pytest_codeblocks/
"
SRC_URI="
	https://github.com/nschloe/pytest-codeblocks/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/pytest-7.0.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	epytest -p pytester
}
