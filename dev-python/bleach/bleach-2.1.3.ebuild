# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_6 pypy3 )

inherit distutils-r1

DESCRIPTION="an easy whitelist-based HTML-sanitizing tool"
HOMEPAGE="https://github.com/mozilla/bleach https://pypi.org/project/bleach/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/html5lib-0.99999999[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( >=dev-python/pytest-3.0.3[${PYTHON_USEDEP}] )
"

python_test() {
	py.test -v || die "tests failed under ${EPYTHON}"
}
