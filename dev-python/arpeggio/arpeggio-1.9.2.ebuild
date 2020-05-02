# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=bdepend
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
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/memory_profiler[${PYTHON_USEDEP}]
	)
"
S=${WORKDIR}/${MY_P}

python_prepare_all() {
	distutils-r1_python_prepare_all
	sed -e 's:packages=find_packages(:\0exclude=["examples", "examples.*"]:' \
		-e "s:\\(setup_requires=\[\\)'pytest-runner'\\(\],\\):\\1\\2:" \
		-i setup.py || die
}

python_test() {
	pytest -vv || die "Testing failed"
}
