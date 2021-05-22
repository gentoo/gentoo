# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1

DESCRIPTION="Logging integration for Click"
HOMEPAGE="
	https://github.com/click-contrib/click-log/
	https://pypi.org/project/click-log/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="dev-python/click[${PYTHON_USEDEP}]"

DOCS=( README.rst )

distutils_enable_tests pytest
