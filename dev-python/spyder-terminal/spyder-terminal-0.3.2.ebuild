# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Run system terminals inside Spyder"
HOMEPAGE="https://github.com/spyder-ide/spyder-terminal"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/coloredlogs[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	>=dev-python/spyder-4.0.0[${PYTHON_USEDEP}]
	dev-python/terminado[${PYTHON_USEDEP}]
	www-servers/tornado[${PYTHON_USEDEP}]
"
