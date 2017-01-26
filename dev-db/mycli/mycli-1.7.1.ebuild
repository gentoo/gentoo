# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4} )
inherit distutils-r1

DESCRIPTION="CLI for MySQL Database with auto-completion and syntax highlighting"

HOMEPAGE="http://mycli.net"
SRC_URI="https://github.com/dbcli/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	>=dev-python/click-4.1[${PYTHON_USEDEP}]
	>=dev-python/configobj-5.0.6[${PYTHON_USEDEP}]
	>=dev-python/prompt_toolkit-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/pycrypto-2.6.1[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.0[${PYTHON_USEDEP}]
	>=dev-python/pymysql-0.6.6[${PYTHON_USEDEP}]
	>=dev-python/python-sqlparse-0.1.19[${PYTHON_USEDEP}]
"

src_prepare() {
	rm mycli/packages/counter.py || die "Could not remove python 2.6 counter.py"
	distutils-r1_src_prepare
}
