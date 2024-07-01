# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1

DESCRIPTION="A Quart extension to provide trio support"
HOMEPAGE="
	https://github.com/pgjones/quart-trio/
	https://pypi.org/project/quart-trio/
"
# no tests in sdist, as of 0.11.1
SRC_URI="
	https://github.com/pgjones/quart-trio/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/exceptiongroup-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/hypercorn-0.12.0[${PYTHON_USEDEP}]
	>=dev-python/quart-0.19[${PYTHON_USEDEP}]
	>=dev-python/trio-0.19.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-trio[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

PATCHES=(
	# https://github.com/pgjones/quart-trio/commit/805686abfd9963be26d59d9da9b11faddd583d11
	"${FILESDIR}/${P}-trio-0.25.patch"
)

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -o addopts= -p trio
}
