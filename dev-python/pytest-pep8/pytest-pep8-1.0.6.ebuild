# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6,7} pypy3 )

inherit distutils-r1

DESCRIPTION="pytest plugin to check PEP8 requirements"
HOMEPAGE="https://pypi.org/project/pytest-pep8/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/pep8-1.3[${PYTHON_USEDEP}]
	>=dev-python/pytest-2.4.2[${PYTHON_USEDEP}]
	dev-python/pytest-cache[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/1.0.6-MANIFEST.patch
)

python_test() {
	${EPYTHON} test_pep8.py || die
}
