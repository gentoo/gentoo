# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Fast JSON encoder/decoder for Python"
HOMEPAGE="https://github.com/AGProjects/python-cjson"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
IUSE=""

KEYWORDS="~amd64 ~x86"

python_test() {
	"${PYTHON}" jsontest.py || die
}
