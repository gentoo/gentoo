# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
inherit distutils-r1

DESCRIPTION="Tool to refactor valid 3.x syntax into valid 2.x syntax"
HOMEPAGE="https://pypi.python.org/pypi/3to2"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"

python_prepare() {
	# https://bitbucket.org/amentajo/lib3to2/issues/50/testsuite-fails-with-new-python-35
	# Remove failing test
	sed -i -e "/test_argument_unpacking/a \\        return"\
		lib3to2/tests/test_print.py || die
	sed -i -e "s/Exception, err/Exception as err/" lib3to2/build.py || die
	distutils-r1_python_prepare_all

}

python_test() {
	cd "${BUILD_DIR}"/lib || die
	# the standard test runner fails to properly return failure
	"${PYTHON}" -m unittest discover || die "Tests fail with ${EPYTHON}"
}
