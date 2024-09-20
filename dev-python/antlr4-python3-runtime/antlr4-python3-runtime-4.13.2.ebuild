# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

MY_P=antlr4-${PV}
DESCRIPTION="Python 3 runtime for ANTLR"
HOMEPAGE="
	https://www.antlr.org/
	https://github.com/antlr/antlr4/
	https://pypi.org/project/antlr4-python3-runtime/
"
SRC_URI="
	https://github.com/antlr/antlr4/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S="${WORKDIR}/${MY_P}/runtime/Python3"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	# https://github.com/antlr/antlr4/pull/4593
	sed -i -e 's:assertEquals:assertEqual:' tests/TestIntervalSet.py || die

	distutils-r1_src_prepare
}

python_test() {
	"${EPYTHON}" tests/run.py -v || die "Tests failed with ${EPYTHON}"
}
