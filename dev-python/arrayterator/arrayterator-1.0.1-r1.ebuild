# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A buffered iterator for reading big arrays in small contiguous blocks"
HOMEPAGE="https://pypi.org/project/arrayterator/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND=">=dev-python/numpy-1.0_rc1[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	cd tests || die

	"${PYTHON}" -c "import test_stochastic; test_stochastic.test()" \
		|| die "Tests fail with ${EPYTHON}"
}
