# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="An implementation of the Debug Adapter Protocol for Python"
HOMEPAGE="https://github.com/microsoft/debugpy/ https://pypi.org/project/debugpy/"
SRC_URI="
	https://github.com/microsoft/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

# This is completely broken
RESTRICT="test"

RDEPEND="dev-python/pydevd[${PYTHON_USEDEP}]"
BDEPEND="test? ( dev-python/pytest-timeout[${PYTHON_USEDEP}] )"

PATCHES=(
	"${FILESDIR}/${PN}-1.6.1-unbundle-pydevd.patch"
)

distutils_enable_tests pytest

python_prepare_all() {
	# Drop unnecessary and unrecognized option
	# __main__.py: error: unrecognized arguments: -n8
	# Do not timeout
	sed -e '/addopts/d' -e '/timeout/d' -i pytest.ini || die

	# Unbundle dev-python/pydevd
	rm -r src/debugpy/_vendored tests/tests/test_vendoring.py || die

	distutils-r1_python_prepare_all
}
