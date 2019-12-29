# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1

DESCRIPTION="A programmatic interface to OTRS SOAP API"
HOMEPAGE="https://pypi.org/project/python-otrs/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""
