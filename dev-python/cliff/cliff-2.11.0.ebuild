# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Command Line Interface Formulation Framework"
HOMEPAGE="https://github.com/dreamhost/cliff"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"

CDEPEND=">=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		>=dev-python/subunit-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testtools-2.2.0[${PYTHON_USEDEP}]
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		>=dev-python/coverage-4.0[${PYTHON_USEDEP}]
		!~dev-python/coverage-4.4[${PYTHON_USEDEP}]
		>=dev-python/bandit-1.1.0[${PYTHON_USEDEP}]
	)
	doc? (
		>=dev-python/sphinx-1.6.2[${PYTHON_USEDEP}]
	)
"
# source files stipulate <sphinx-1.3 however build effected perfectly with sphinx-1.3.1
RDEPEND="
	${CDEPEND}
	>=dev-python/cmd2-0.6.7[${PYTHON_USEDEP}]
	>=dev-python/prettytable-0.7.1[${PYTHON_USEDEP}]
	<dev-python/prettytable-0.8[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.20.0[${PYTHON_USEDEP}]
	>=dev-python/unicodecsv-0.8.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.10.0[${PYTHON_USEDEP}]
	"

python_compile() {
	use doc && esetup.py build_sphinx
}

python_test() {
	nosetests ${PN}/tests || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/build/html/. )
	distutils-r1_python_install_all
}
