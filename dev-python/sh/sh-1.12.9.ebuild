# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6} )

inherit distutils-r1

DESCRIPTION="Python subprocess interface"
HOMEPAGE="https://github.com/amoffat/sh"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}/sh-1.12.9-python2-unicode-tests.patch"
)

python_test() {
	${PYTHON} test.py || die
}
