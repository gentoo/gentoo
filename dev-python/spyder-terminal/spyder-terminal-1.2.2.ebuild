# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Run system terminals inside Spyder"
HOMEPAGE="https://github.com/spyder-ide/spyder-terminal"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT BSD Apache-2.0 BSD-2 ISC CC-BY-4.0 ZLIB WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/coloredlogs[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	>=dev-python/spyder-5.2.0[${PYTHON_USEDEP}]
	>=dev-python/terminado-0.13.1[${PYTHON_USEDEP}]
	dev-python/tornado[${PYTHON_USEDEP}]
"
