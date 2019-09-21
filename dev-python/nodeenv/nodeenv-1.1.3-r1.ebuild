# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_5,3_6,3_7} pypy )

inherit distutils-r1

DESCRIPTION="Node.js virtual environment builder"
HOMEPAGE="https://github.com/ekalinin/nodeenv"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
