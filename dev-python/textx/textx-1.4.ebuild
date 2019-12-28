# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1

MY_PN=textX
MY_P=${MY_PN}-${PV}
DESCRIPTION="Meta-language for DSL implementation inspired by Xtext"
HOMEPAGE="https://pypi.org/project/textX/ https://github.com/igordejanovic/textX"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
# pypi tarball omits tests
RESTRICT="test"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/arpeggio[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"
S=${WORKDIR}/${MY_P}

python_test() {
	py.test -v tests/functional || die "tests failed"
}
