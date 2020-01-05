# Copyright 2018-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} pypy3 )
inherit distutils-r1

MY_P=py-filelock-${PV}
DESCRIPTION="A platform independent file lock for Python"
HOMEPAGE="https://github.com/benediktschmitt/py-filelock
	https://pypi.org/project/filelock/"
SRC_URI="https://github.com/benediktschmitt/py-filelock/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

S=${WORKDIR}/${MY_P}

src_prepare() {
	# test_del is relying on CPython behavior, so it breaks PyPy
	# (and it's not very valuable anyway)
	sed -i -e '/test_del/i\ \ \ \ @unittest.skipIf(hasattr(sys, "pypy_version_info"), "del() does not trigger GC on PyPy")' test.py || die

	distutils-r1_src_prepare
}

python_test() {
	"${EPYTHON}" test.py -v || die "Tests fail with ${EPYTHON}"
}
