# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

MY_PN=Arpeggio
MY_P=${MY_PN}-${PV}
DESCRIPTION="Parser interpreter based on PEG grammars"
HOMEPAGE="https://pypi.org/project/Arpeggio/ https://github.com/igordejanovic/Arpeggio"
SRC_URI="https://github.com/igordejanovic/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/memory_profiler[${PYTHON_USEDEP}]
	)
"
S=${WORKDIR}/${MY_P}

python_test() {
	pytest -vv || die "Testing failed"
}
