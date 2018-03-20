# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_5,3_6} )
inherit distutils-r1

DESCRIPTION="Pythonic task execution"
HOMEPAGE="https://pypi.python.org/pypi/invoke/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
