# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

MY_PN=Arpeggio
MY_P=${MY_PN}-${PV}
DESCRIPTION="Parser interpreter based on PEG grammars"
HOMEPAGE="https://pypi.org/project/Arpeggio/ https://github.com/igordejanovic/Arpeggio"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
# pypi tarball omits tests
RESTRICT="test"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"
S=${WORKDIR}/${MY_P}

python_test() {
	py.test -v tests || die "tests failed"
}
