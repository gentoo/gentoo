# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="Manage external processes across test runs"
HOMEPAGE="https://pypi.org/project/pytest-xprocess/ https://github.com/pytest-dev/pytest-xprocess"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/pytest-xprocess-0.12.1-pytest-28.patch
)

distutils_enable_tests pytest

src_prepare() {
	# Upstream's package mistakenly includes __pycache__ directory that make
	# tests fail.
	rm -r example/__pycache__ || die
	distutils-r1_src_prepare
}
