# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )
PYTHON_REQ_USE="sqlite?"
inherit distutils-r1

DESCRIPTION="A lightweight password-manager with multiple database backends"
HOMEPAGE="https://pwman3.github.io/pwman3/"
SRC_URI="https://github.com/pwman3/pwman3/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="mongodb mysql postgres +sqlite test"
RESTRICT="!test? ( test )"

COMMON="
	>=dev-python/cryptography-2.3[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.3.0[${PYTHON_USEDEP}]
	"

DEPEND="
	${COMMON}
	test? ( dev-python/pexpect[${PYTHON_USEDEP}] )
	"

RDEPEND="
	${COMMON}
	mongodb? ( dev-python/pymongo[${PYTHON_USEDEP}] )
	mysql? ( dev-python/pymysql[${PYTHON_USEDEP}] )
	postgres? ( dev-python/psycopg[${PYTHON_USEDEP}] )
	"

python_test() {
	esetup.py test
}
