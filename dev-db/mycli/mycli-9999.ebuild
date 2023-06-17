# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=yes
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 git-r3

DESCRIPTION="CLI for MySQL Database with auto-completion and syntax highlighting"
HOMEPAGE="
	https://www.mycli.net/
	https://github.com/dbcli/mycli/
	https://pypi.org/project/mycli/
"
EGIT_REPO_URI="https://github.com/dbcli/mycli.git"

LICENSE="BSD MIT"
SLOT="0"
IUSE="ssh"

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/cli_helpers-2.0.1[${PYTHON_USEDEP}]
		>=dev-python/click-7.0[${PYTHON_USEDEP}]
		>=dev-python/configobj-5.0.6[${PYTHON_USEDEP}]
		>=dev-python/cryptography-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/prompt-toolkit-3.0.0[${PYTHON_USEDEP}]
		<dev-python/prompt-toolkit-4.0.0[${PYTHON_USEDEP}]
		dev-python/pyaes[${PYTHON_USEDEP}]
		>=dev-python/pygments-2.0[${PYTHON_USEDEP}]
		>=dev-python/pymysql-0.9.2[${PYTHON_USEDEP}]
		dev-python/pyperclip[${PYTHON_USEDEP}]
		>=dev-python/sqlparse-0.3.0[${PYTHON_USEDEP}]
		<dev-python/sqlparse-0.5.0[${PYTHON_USEDEP}]
		ssh? ( dev-python/paramiko[${PYTHON_USEDEP}] )'
	)
"
BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/mock[${PYTHON_USEDEP}]
			dev-python/paramiko[${PYTHON_USEDEP}]
		')
	)
"

distutils_enable_tests pytest

PATCHES=( "${FILESDIR}/mycli-1.21.1-fix-test-install.patch" )

python_test() {
	local EPYTEST_IGNORE=(
		setup.py
		mycli/magic.py
		mycli/packages/parseutils.py
		test/features
		mycli/packages/paramiko_stub/__init__.py
	)
	epytest --capture=sys --doctest-modules --doctest-ignore-import-errors
}
