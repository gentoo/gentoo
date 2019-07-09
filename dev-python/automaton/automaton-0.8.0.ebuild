# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 python3_5 )

inherit distutils-r1

DESCRIPTION="Friendly state machines for python."
HOMEPAGE="https://pypi.org/project/automaton/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

CDEPEND=">=dev-python/pbr-1.6[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"
RDEPEND="${CDEPEND}
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/debtcollector-0.3.0[${PYTHON_USEDEP}]
	>=dev-python/prettytable-0.7.0[${PYTHON_USEDEP}]
	<dev-python/prettytable-0.8.0[${PYTHON_USEDEP}]"
