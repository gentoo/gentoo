# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="pytest plugin to check PEP8 requirements"
HOMEPAGE="https://pypi.org/project/pytest-pep8/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/pep8-1.7.1-r1[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	test? (
		>=dev-python/pytest-5.4.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-cache-1.0-r3[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/1.0.6-MANIFEST.patch
)

python_test() {
	${EPYTHON} test_pep8.py || die "Tests fail with ${EPYTHON}"
}
