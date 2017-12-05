# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy )
PYTHON_REQ_USE="sqlite?"

inherit distutils-r1 eutils flag-o-matic

MY_PN="SQLAlchemy"
MY_P="${MY_PN}-${PV/_beta/b}"

DESCRIPTION="Python SQL toolkit and Object Relational Mapper"
HOMEPAGE="http://www.sqlalchemy.org/ https://pypi.python.org/pypi/SQLAlchemy"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc examples +sqlite test"

REQUIRED_USE="test? ( sqlite )"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7 pypy)
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
	# Create copies of necessary files in BUILD_DIR.
	# https://bitbucket.org/zzzeek/sqlalchemy/issue/3144/
	cp -pR examples sqla_nose.py setup.cfg test "${BUILD_DIR}" || die
	pushd "${BUILD_DIR}" > /dev/null || die
	if [[ "${EPYTHON}" == "python3.2" ]]; then
		2to3 --no-diffs -w test || die
	fi
	# Recently upstream elected to make the testsuite also pytest capable
	# "${PYTHON}" sqla_nose.py || die "Testsuite failed under ${EPYTHON}"
	py.test --verbose test || die "Testsuite failed under ${EPYTHON}"
	popd > /dev/null
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
