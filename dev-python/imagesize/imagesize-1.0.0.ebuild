# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy{,3} python{2_7,3_{4,5,6}} )

inherit distutils-r1

DESCRIPTION="Pure Python module for getting image size from png/jpeg/jpeg2000/gif files"
HOMEPAGE="https://github.com/shibukawa/imagesize_py"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x64-solaris"
IUSE="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"
RDEPEND=""

python_test() {
	py.test || die "tests failed with ${EPYTHON}"
}
