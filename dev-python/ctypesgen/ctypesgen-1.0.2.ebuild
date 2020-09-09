# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# pkg compiles fine with py3_{8,9} but tests fail
# https://github.com/davidjamesca/ctypesgen/issues/90
PYTHON_COMPAT=( python3_7 )

DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Python wrapper generator for ctypes"
HOMEPAGE="https://github.com/davidjamesca/ctypesgen"
SRC_URI="https://github.com/davidjamesca/ctypesgen/archive/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}-${PN}-${PV}"

python_test() {
	"${PYTHON}" "${PN}/test/testsuite.py" || die "Test ${f} fails with ${EPYTHON}"
}
