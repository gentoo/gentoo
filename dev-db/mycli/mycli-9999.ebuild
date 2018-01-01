# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
EGIT_REPO_URI="https://github.com/dbcli/mycli.git"
inherit distutils-r1 git-r3

DESCRIPTION="CLI for MySQL Database with auto-completion and syntax highlighting"

HOMEPAGE="http://mycli.net"
SRC_URI=""
LICENSE="BSD MIT"
SLOT="0"
KEYWORDS=""
IUSE=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	>=dev-python/click-4.1[${PYTHON_USEDEP}]
	>=dev-python/configobj-5.0.6[${PYTHON_USEDEP}]
	>=dev-python/cryptography-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/prompt_toolkit-1.0.10[${PYTHON_USEDEP}]
	!>=dev-python/prompt_toolkit-1.1.0
	>=dev-python/pygments-2.0[${PYTHON_USEDEP}]
	>=dev-python/pymysql-0.6.7[${PYTHON_USEDEP}]
	>=dev-python/python-sqlparse-0.2.2[${PYTHON_USEDEP}]
	!>=dev-python/python-sqlparse-0.3.0
"
