# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy )

inherit distutils-r1

DESCRIPTION="coloured output for nosetests"
HOMEPAGE="http://gfxmonk.net/dist/0install/rednose.xml"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc64 x86"
IUSE=""

DEPEND=""
RDEPEND=">=dev-python/python-termstyle-0.1.7[${PYTHON_USEDEP}]"
