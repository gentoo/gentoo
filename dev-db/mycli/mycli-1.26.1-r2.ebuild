# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=yes
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1

DESCRIPTION="CLI for MySQL Database with auto-completion and syntax highlighting"
HOMEPAGE="
	https://www.mycli.net/
	https://github.com/dbcli/mycli/
	https://pypi.org/project/mycli/
"
SRC_URI="
	https://github.com/dbcli/mycli/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="ssh"

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/cli_helpers-2.2.1[${PYTHON_USEDEP}]
		>=dev-python/click-7.0[${PYTHON_USEDEP}]
		>=dev-python/configobj-5.0.5[${PYTHON_USEDEP}]
		>=dev-python/cryptography-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/prompt-toolkit-3.0.6[${PYTHON_USEDEP}]
		<dev-python/prompt-toolkit-4.0.0[${PYTHON_USEDEP}]
		>=dev-python/pyaes-1.6.1[${PYTHON_USEDEP}]
		>=dev-python/pygments-1.6[${PYTHON_USEDEP}]
		>=dev-python/pymysql-0.9.2[${PYTHON_USEDEP}]
		>=dev-python/pyperclip-1.8.1[${PYTHON_USEDEP}]
		>=dev-python/sqlglot-5.1.3[${PYTHON_USEDEP}]
		>=dev-python/sqlparse-0.3.0[${PYTHON_USEDEP}]
		<dev-python/sqlparse-0.5.0[${PYTHON_USEDEP}]
		ssh? ( dev-python/paramiko[${PYTHON_USEDEP}] )'
	)
"
BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/paramiko[${PYTHON_USEDEP}]
		')
	)
"

EPYTEST_DESELECT=(
	# Fails after a seemingly benign change in sqlparse 0.4.3
	# https://github.com/dbcli/mycli/issues/1103
	"test/test_smart_completion_public_schema_only.py::test_auto_escaped_col_names"
	# Requires a running mysql daemon
	"test/test_main.py::test_batch"
	"test/test_main.py::test_execute"
	"test/test_main.py::test_init"
	"test/test_special_iocommands.py::test_favorite_query"
	"test/test_special_iocommands.py::test_watch"
	"test/test_tabular_output.py::test_sql_output"
)

EPYTEST_IGNORE=(
	# Requires a running mysql daemon
	"test/test_sqlexecute.py"
)

distutils_enable_tests pytest

PATCHES=( "${FILESDIR}/mycli-1.21.1-fix-test-install.patch" )

src_prepare() {
	default

	# Remove unnecessary pin, we have paramiko 3.2.0.
	# https://github.com/dbcli/mycli/commit/eaddc5ca3e208d66fd4f400b90eb76089dd35e4c
	sed -i -e 's:==:>=:' setup.py || die
}
