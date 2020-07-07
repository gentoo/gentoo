# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7} )
DISTUTILS_SINGLE_IMPL=yes
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="CLI for MySQL Database with auto-completion and syntax highlighting"

HOMEPAGE="https://www.mycli.net"
SRC_URI="https://github.com/dbcli/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssh test"
RESTRICT="!test? ( test )"
RDEPEND="$(python_gen_cond_dep '
	>=dev-python/cli_helpers-1.1.0[${PYTHON_MULTI_USEDEP}]
	>=dev-python/click-7.0[${PYTHON_MULTI_USEDEP}]
	>=dev-python/configobj-5.0.6[${PYTHON_MULTI_USEDEP}]
	>=dev-python/cryptography-1.0.0[${PYTHON_MULTI_USEDEP}]
	>=dev-python/prompt_toolkit-3.0.0[${PYTHON_MULTI_USEDEP}]
	<dev-python/prompt_toolkit-4.0.0[${PYTHON_MULTI_USEDEP}]
	>=dev-python/pygments-2.0[${PYTHON_MULTI_USEDEP}]
	>=dev-python/pymysql-0.9.2[${PYTHON_MULTI_USEDEP}]
	>=dev-python/sqlparse-0.3.0[${PYTHON_MULTI_USEDEP}]
	<dev-python/sqlparse-0.4.0[${PYTHON_MULTI_USEDEP}]
	ssh? ( dev-python/paramiko[${PYTHON_MULTI_USEDEP}] )')
"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest

BDEPEND="test? ( $(python_gen_cond_dep 'dev-python/mock[${PYTHON_MULTI_USEDEP}]') )"

PATCHES=( "${FILESDIR}/mycli-1.21.1-fix-test-install.patch" )

python_test() {
	pytest --capture=sys \
		--showlocals \
		--doctest-modules \
		--doctest-ignore-import-errors \
		--ignore=setup.py \
		--ignore=mycli/magic.py \
		--ignore=mycli/packages/parseutils.py \
		--ignore=test/features
}
