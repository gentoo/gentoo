# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7} pypy3 )

inherit distutils-r1

DESCRIPTION="A library for parsing ISO 8601 strings"
HOMEPAGE="https://bitbucket.org/nielsenb/aniso8601/ https://pypi.org/project/aniso8601/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-python/python-dateutil-2.7.3[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( $(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7) )"

PATCHES=( "${FILESDIR}"/${P}-mock.patch )

python_test() {
	"${PYTHON}" -m unittest discover ${PN}/tests -v || die "tests fail with ${EPYTHON}"
}
