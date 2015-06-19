# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/sqlalchemy/sqlalchemy-1.0.4.ebuild,v 1.1 2015/05/26 02:29:17 patrick Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )
PYTHON_REQ_USE="sqlite?"

inherit distutils-r1 flag-o-matic

MY_PN="SQLAlchemy"
MY_P="${MY_PN}-${PV/_beta/b}"

DESCRIPTION="Python SQL toolkit and Object Relational Mapper"
HOMEPAGE="http://www.sqlalchemy.org/ http://pypi.python.org/pypi/SQLAlchemy"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc examples +sqlite test"
REQUIRED_USE="test? ( sqlite )"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}
	test? (	dev-python/pytest[${PYTHON_USEDEP}]
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
	pushd "${BUILD_DIR}" > /dev/null
	if [[ "${EPYTHON}" == "python3.2" ]]; then
		2to3 --no-diffs -w test
	fi
	# Recently upstream elected to make the testsuite also pytest capable
	# "${PYTHON}" sqla_nose.py || die "Testsuite failed under ${EPYTHON}"
	py.test test || die "Testsuite failed under ${EPYTHON}"
	popd > /dev/null
}

python_install_all() {
	use doc && HTML_DOCS=( doc/. )

	use examples && local EXAMPLES=( examples/. )

	distutils-r1_python_install_all
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		if ! has_version dev-python/mysql-python; then
		        elog "For MySQL support, install dev-python/mysql-python"
		fi

		if ! has_version dev-python/pymssql; then
			elog "For mssql support, install dev-python/pymssql"
		fi

		if ! has_version dev-python/psycopg:2; then
			elog "For postgresql support, install dev-python/psycopg:2"
		fi
	fi

	elog "mysql backend support can be enabled by installing mysql-python for cpython py2.7 only,"
	elog "or mysql-connector-python for support of cpythons 2.7 3.3 and 3.4"
}
