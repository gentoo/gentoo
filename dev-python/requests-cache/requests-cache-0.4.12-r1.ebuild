# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )

inherit distutils-r1

HOMEPAGE="https://pypi.org/project/requests-cache/"
DESCRIPTION="Persistent cache for requests library"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

# Portage only has versions of request >= minimum border
RDEPEND=">=dev-python/requests-2.6[${PYTHON_USEDEP}]"
DEPEND="
	app-arch/unzip"

distutils_enable_sphinx docs
# Testsuite excels in tests connecting to the network via local server daemons
#distutils_enable_tests setup.py
