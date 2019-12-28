# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )
inherit distutils-r1

DESCRIPTION="distutils extension to work with PyQt applications and UI files"
HOMEPAGE="https://github.com/ColinDuquesnoy/pyqt_distutils"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

RDEPEND="
	${DEPEND}
	dev-python/docopt[${PYTHON_USEDEP}]
"
