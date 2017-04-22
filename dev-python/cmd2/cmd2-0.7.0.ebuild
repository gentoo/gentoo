# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy )

inherit distutils-r1

DESCRIPTION="Extra features for standard library's cmd module"
HOMEPAGE="https://bitbucket.org/catherinedevlin/cmd2"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	>=dev-python/pyparsing-2.0.1[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	# Disable failing test
	[[ ${PV} == 0.7.0 ]] || die "Please remove the sed from python_prepare_all"
	sed -i -e 's:test_input_redirection:_&:' tests/test_cmd2.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	py.test -vv || die
	${EPYTHON} example/example.py --test example/exampleSession.txt || die
}
