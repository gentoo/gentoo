# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Simple MSSQL python extension module"
HOMEPAGE="http://www.pymssql.org/ https://pypi.python.org/pypi/pymssql"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="test"

# tests need a running instance of freetds
RESTRICT="test"

RDEPEND=">=dev-db/freetds-0.63[mssql]"
DEPEND="
	${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/unittest2[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.3-DBVERSION_80.patch
	"${FILESDIR}"/${PN}-2.1.3-remove-setuptools_git.patch
)

python_prepare_all() {
	# delete stale cython .c file
	# this can cause issues with the patches
	rm {_mssql,pymssql}.c || die

	distutils-r1_python_prepare_all
}

python_test() {
	py.test -v || die "Tests fail with ${EPYTHON}"
}
