# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Utility for mocking out the Python Requests library"
HOMEPAGE="
	https://pypi.org/project/responses/
	https://github.com/getsentry/responses/
"
SRC_URI="
	https://github.com/getsentry/responses/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
	https://github.com/getsentry/responses/pull/596.patch
		-> ${P}-tomli.patch
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	<dev-python/requests-3[${PYTHON_USEDEP}]
	>=dev-python/requests-2.22.0[${PYTHON_USEDEP}]
	dev-python/tomli[${PYTHON_USEDEP}]
	dev-python/tomli-w[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.25.10[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/pytest-httpserver[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

PATCHES=(
	"${DISTDIR}"/${P}-tomli.patch
)

python_test() {
	epytest -p no:localserver
}
