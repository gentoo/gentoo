# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} pypy3 )
PYTHON_REQ_USE="sqlite?"

inherit distutils-r1 eutils flag-o-matic

MY_PN="SQLAlchemy"
MY_P="${MY_PN}-${PV/_beta/b}"

DESCRIPTION="Python SQL toolkit and Object Relational Mapper"
HOMEPAGE="http://www.sqlalchemy.org/ https://pypi.org/project/SQLAlchemy/"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris"
IUSE="doc examples +sqlite test"
RESTRICT="!test? ( test )"

REQUIRED_USE="test? ( sqlite )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	# Disable tests hardcoding function call counts specific to Python versions.
	rm -r test/aaa_profiling || die
	distutils-r1_python_prepare_all
}

python_compile() {
	if ! python_is_python3; then
		local CFLAGS=${CFLAGS}
		append-cflags -fno-strict-aliasing
	fi
	distutils-r1_python_compile
}

python_test() {
	pytest -vv test || die "Testsuite failed under ${EPYTHON}"
}

python_install_all() {
	use doc && HTML_DOCS=( doc/. )
	use examples && dodoc -r examples

	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "MySQL support" dev-python/mysql-python dev-python/mysql-connector-python
	optfeature "mssql support" dev-python/pymssql
	optfeature "postgresql support" dev-python/psycopg:2
}
