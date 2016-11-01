# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1

DESCRIPTION="A CLI, cURL-like tool for humans"
HOMEPAGE="http://httpie.org/ https://pypi.python.org/pypi/httpie"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	>=dev-python/requests-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/pygments-1.5[${PYTHON_USEDEP}]"
