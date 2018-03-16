# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Python library for Intel HEX files manipulations"
HOMEPAGE="https://pypi.python.org/pypi/IntelHex/ https://github.com/bialix/intelhex"
SRC_URI="mirror://pypi/I/IntelHex/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~x86"
IUSE=""
