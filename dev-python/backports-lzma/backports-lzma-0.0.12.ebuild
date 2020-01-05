# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN=${PN/-/.}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Backport of Python 3.3's lzma module for XZ/LZMA compressed files"
HOMEPAGE="https://github.com/peterjc/backports.lzma/ https://pypi.org/project/backports.lzma/"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="app-arch/xz-utils:0=
	dev-python/backports[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( app-arch/xz-utils:0[extra-filters(+)] )"

S=${WORKDIR}/${MY_P}

python_test() {
	"${EPYTHON}" test/test_lzma.py || die "tests failed with ${EPYTHON}"
}

python_install() {
	# main namespace provided by dev-python/backports
	rm "${BUILD_DIR}"/lib/backports/__init__.py || die
	rm -f backports/__init__.py || die

	distutils-r1_python_install
}
