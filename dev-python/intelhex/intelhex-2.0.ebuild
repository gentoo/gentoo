# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1

DESCRIPTION="Python library for Intel HEX files manipulations"
HOMEPAGE="https://pypi.org/project/IntelHex/ https://github.com/bialix/intelhex"
SRC_URI="mirror://pypi/I/IntelHex/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~x86"
IUSE=""
