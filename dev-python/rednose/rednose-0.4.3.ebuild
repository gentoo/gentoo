# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{5,6,7} pypy )

inherit distutils-r1

DESCRIPTION="coloured output for nosetests"
HOMEPAGE="http://gfxmonk.net/dist/0install/rednose.xml"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

CDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}"
RDEPEND="
	${CDEPEND}
	dev-python/colorama[${PYTHON_USEDEP}]
	>=dev-python/python-termstyle-0.1.7[${PYTHON_USEDEP}]
"
