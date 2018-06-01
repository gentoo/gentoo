# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="A dockerized approach to test a Gentoo package within a clean stage3"
HOMEPAGE="http://ebuildtester.readthedocs.io/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	app-emulation/docker
"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
