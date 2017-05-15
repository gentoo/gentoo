# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python{3_4,3_5,3_6} )
inherit distutils-r1

DESCRIPTION="Simple decorator to set attributes of target function or class in a DRY way"
HOMEPAGE="https://github.com/denis-ryzhkov/attr"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

python_test() {
	${EPYTHON} -c "import attr; attr.test()" || die
}
