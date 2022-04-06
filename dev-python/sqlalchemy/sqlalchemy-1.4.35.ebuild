# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..10} )
PYTHON_REQ_USE="sqlite?"

inherit distutils-r1 optfeature

MY_PN="SQLAlchemy"
MY_P="${MY_PN}-${PV/_beta/b}"

DESCRIPTION="Python SQL toolkit and Object Relational Mapper"
HOMEPAGE="
	https://www.sqlalchemy.org/
	https://pypi.org/project/SQLAlchemy/
	https://github.com/sqlalchemy/sqlalchemy/
"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="examples +sqlite test"

BDEPEND="
	test? (
		$(python_gen_impl_dep sqlite)
	)
"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# hardcode call counts specific to Python versions
	test/aaa_profiling
)

src_prepare() {
	sed -i -e '/greenlet/d' setup.cfg || die
	distutils-r1_src_prepare
}

python_test() {
	local EPYTEST_DESELECT=()
	[[ ${EPYTHON} == pypy3 ]] && EPYTEST_DESELECT+=(
		test/ext/test_associationproxy.py::ProxyHybridTest::test_msg_fails_on_cls_access
	)

	# upstream's test suite is horribly hacky; it relies on disabling
	# the warnings plugin and turning warnings into errors;  this also
	# means that any DeprecationWarnings from third-party plugins cause
	# everything to explode
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=
	# upstream automagically depends on xdist when it is importable
	if has_version "dev-python/pytest-xdist[${PYTHON_USEDEP}]"; then
		PYTEST_PLUGINS+=xdist.plugin
	fi
	epytest
}

python_install_all() {
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		dodoc -r examples
	fi

	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "asyncio support" dev-python/greenlet
	optfeature "MySQL support" \
		dev-python/mysqlclient \
		dev-python/pymysql \
		dev-python/mysql-connector-python
	optfeature "mssql support" dev-python/pymssql
	optfeature "postgresql support" dev-python/psycopg:2
}
