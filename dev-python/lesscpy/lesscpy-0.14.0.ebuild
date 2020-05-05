# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

RESTRICT="!test? ( test )"

DESCRIPTION="A compiler written in Python for the LESS language"
HOMEPAGE="https://pypi.org/project/lesscpy/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

BDEPEND="test? ( dev-python/nose[${PYTHON_USEDEP}] )"
RDEPEND="dev-python/ply[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]"

python_test() {
	nosetests -v || die "tests failed under ${EPYTHON}"
}
