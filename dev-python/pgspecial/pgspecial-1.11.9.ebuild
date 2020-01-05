# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit distutils-r1

DESCRIPTION="Python implementation of postgres meta commands"
HOMEPAGE="https://github.com/dbcli/pgspecial"
SRC_URI="https://github.com/dbcli/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-python/click-4.1[${PYTHON_USEDEP}]
	>=dev-python/psycopg-2.7.4[${PYTHON_USEDEP}]
	>=dev-python/python-sqlparse-0.1.19[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
