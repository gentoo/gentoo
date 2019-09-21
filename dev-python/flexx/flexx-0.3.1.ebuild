# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_5 )

inherit distutils-r1

DESCRIPTION="Pure Python toolkit for creating GUI's using web technology"
HOMEPAGE="
	https://flexx.readthedocs.org
	https://github.com/zoofio/flexx
	https://pypi.org/project/flexx/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
