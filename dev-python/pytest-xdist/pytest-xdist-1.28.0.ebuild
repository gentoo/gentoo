# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} pypy3 )

inherit distutils-r1

DESCRIPTION="Distributed testing and loop-on-failing modes"
HOMEPAGE="https://pypi.org/project/pytest-xdist/ https://github.com/pytest-dev/pytest-xdist"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/execnet[${PYTHON_USEDEP}]
	>=dev-python/pytest-4.4[${PYTHON_USEDEP}]
	dev-python/pytest-forked[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/filelock[${PYTHON_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}/${PN}-1.28.0-strip-setuptools-scm.patch"
)

python_test() {
	distutils_install_for_testing
	pytest -vv testing || die "Tests failed under ${EPYTHON}"
}
