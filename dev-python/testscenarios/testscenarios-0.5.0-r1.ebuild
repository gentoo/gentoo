# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} pypy3 )

inherit distutils-r1

DESCRIPTION="A pyunit extension for dependency injection"
HOMEPAGE="https://launchpad.net/testscenarios"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/testtools[${PYTHON_USEDEP}]"

# using pytest for tests since unittest loader fails with py3.5+
DEPEND="
	>=dev-python/pbr-0.11[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_prepare_all() {
	# Remove a faulty file from tests, missing a required attribute
	rm ${PN}/tests/test_testcase.py || die
	distutils-r1_python_prepare_all
}
