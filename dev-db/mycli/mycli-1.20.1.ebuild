# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7} )
inherit distutils-r1

DESCRIPTION="CLI for MySQL Database with auto-completion and syntax highlighting"

HOMEPAGE="https://www.mycli.net"
SRC_URI="https://github.com/dbcli/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssh test"
RESTRICT="!test? ( test )"
RDEPEND="
	>=dev-python/cli_helpers-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/click-7.0[${PYTHON_USEDEP}]
	>=dev-python/configobj-5.0.6[${PYTHON_USEDEP}]
	>=dev-python/cryptography-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/prompt_toolkit-2.0.6[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.0[${PYTHON_USEDEP}]
	>=dev-python/pymysql-0.9.2[${PYTHON_USEDEP}]
	>=dev-python/python-sqlparse-0.3.0[${PYTHON_USEDEP}]
	<dev-python/python-sqlparse-0.4.0[${PYTHON_USEDEP}]
	ssh? ( dev-python/paramiko[${PYTHON_USEDEP}] )
"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] ${RDEPEND} )"

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
