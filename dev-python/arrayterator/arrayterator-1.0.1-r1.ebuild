# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/arrayterator/arrayterator-1.0.1-r1.ebuild,v 1.4 2015/04/08 08:05:18 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A buffered iterator for reading big arrays in small contiguous blocks"
HOMEPAGE="http://pypi.python.org/pypi/arrayterator"
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
