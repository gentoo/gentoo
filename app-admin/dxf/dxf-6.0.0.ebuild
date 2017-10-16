# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
inherit distutils-r1

DESCRIPTION="Docker registry v2 client in Python"
HOMEPAGE="https://github.com/davedoesdev/dxf"
SRC_URI="mirror://pypi/p/python-${PN}/python-${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=dev-python/jwcrypto-0.4.2[${PYTHON_USEDEP}]
	>=dev-python/requests-2.9.0[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.10.0[${PYTHON_USEDEP}]
	>=dev-python/www-authenticate-0.9.2[${PYTHON_USEDEP}]"

S=${WORKDIR}/python-${P}

RESTRICT="test"
# Fixtures and Makefile missing on pypi
# No tag in upstream repository
