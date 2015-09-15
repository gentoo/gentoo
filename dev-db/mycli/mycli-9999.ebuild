# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )
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
	>=dev-python/pygments-2.0[${PYTHON_USEDEP}]
	=dev-python/prompt_toolkit-0.46[${PYTHON_USEDEP}]
	>=dev-python/pymysql-0.6.6[${PYTHON_USEDEP}]
	>=dev-python/python-sqlparse-0.1.16[${PYTHON_USEDEP}]
"

src_prepare() {
	rm mycli/packages/counter.py || die "Could not remove python 2.6 counter.py"
	distutils-r1_src_prepare
}
