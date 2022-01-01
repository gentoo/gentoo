# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_7,3_8} )
DISTUTILS_SINGLE_IMPL=yes
DISTUTILS_USE_SETUPTOOLS=rdepend
EGIT_REPO_URI="https://github.com/dbcli/mycli.git"
inherit distutils-r1 git-r3

DESCRIPTION="CLI for MySQL Database with auto-completion and syntax highlighting"

HOMEPAGE="https://www.mycli.net"
SRC_URI=""
LICENSE="BSD MIT"
SLOT="0"
KEYWORDS=""
IUSE="ssh test"
RESTRICT="!test? ( test )"
RDEPEND="$(python_gen_cond_dep '
	>=dev-python/cli_helpers-2.0.1[${PYTHON_USEDEP}]
	>=dev-python/click-7.0[${PYTHON_USEDEP}]
	>=dev-python/configobj-5.0.6[${PYTHON_USEDEP}]
	>=dev-python/cryptography-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/prompt_toolkit-3.0.0[${PYTHON_USEDEP}]
	<dev-python/prompt_toolkit-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.0[${PYTHON_USEDEP}]
	>=dev-python/pymysql-0.9.2[${PYTHON_USEDEP}]
	>=dev-python/sqlparse-0.3.0[${PYTHON_USEDEP}]
	<dev-python/sqlparse-0.5.0[${PYTHON_USEDEP}]
	ssh? ( dev-python/paramiko[${PYTHON_USEDEP}] )')
"
DEPEND="${RDEPEND}"
BDEPEND="test? ( $(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]') )"

distutils_enable_tests pytest

PATCHES=( "${FILESDIR}/mycli-1.21.1-fix-test-install.patch" )

python_test() {
	pytest --capture=sys \
		--showlocals \
		--doctest-modules \
		--doctest-ignore-import-errors \
		--ignore=setup.py \
		--ignore=mycli/magic.py \
		--ignore=mycli/packages/parseutils.py \
		--ignore=test/features \
		--ignore=mycli/packages/paramiko_stub/__init__.py
}
