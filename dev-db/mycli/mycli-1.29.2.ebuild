# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=yes
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..12} )

inherit distutils-r1 pypi

DESCRIPTION="CLI for MySQL Database with auto-completion and syntax highlighting"
HOMEPAGE="
	https://www.mycli.net/
	https://github.com/dbcli/mycli/
	https://pypi.org/project/mycli/
"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="ssh"

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/cli-helpers-2.2.1[${PYTHON_USEDEP}]
		>=dev-python/click-7.0[${PYTHON_USEDEP}]
		>=dev-python/configobj-5.0.5[${PYTHON_USEDEP}]
		>=dev-python/cryptography-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/prompt-toolkit-3.0.6[${PYTHON_USEDEP}]
		<dev-python/prompt-toolkit-4.0.0[${PYTHON_USEDEP}]
		>=dev-python/pyaes-1.6.1[${PYTHON_USEDEP}]
		>=dev-python/pyfzf-0.3.1[${PYTHON_USEDEP}]
		>=dev-python/pygments-1.6[${PYTHON_USEDEP}]
		>=dev-python/pymysql-0.9.2[${PYTHON_USEDEP}]
		>=dev-python/pyperclip-1.8.1[${PYTHON_USEDEP}]
		>=dev-python/sqlglot-5.1.3[${PYTHON_USEDEP}]
		>=dev-python/sqlparse-0.3.0[${PYTHON_USEDEP}]
		ssh? (
			dev-python/paramiko[${PYTHON_USEDEP}]
			dev-python/sshtunnel[${PYTHON_USEDEP}]
		)
	')
"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/setuptools-scm[${PYTHON_USEDEP}]
		test? (
			dev-python/paramiko[${PYTHON_USEDEP}]
		)
	')
"

EPYTEST_DESELECT=(
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

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

src_prepare() {
	default

	# Relax sqlparse requirement, 0.5.0 didn't have major API changes that would necessitate this restriction.
	# bug #930690
	sed -i -e '/sqlparse/ s/,<0.5.0//' pyproject.toml || die
}
