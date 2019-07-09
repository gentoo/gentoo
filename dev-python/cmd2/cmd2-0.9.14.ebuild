# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{3_5,3_6,3_7} )

inherit distutils-r1

DESCRIPTION="Extra features for standard library's cmd module"
HOMEPAGE="https://github.com/python-cmd2/cmd2"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/pyperclip[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/wcwidth[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python3_5)
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	# disable test relying on paste buffer
	sed -i -e 's:test_send_to_paste_buffer:_&:' tests/test_cmd2.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	# test rely on very specific text wrapping...
	local -x COLUMNS=80
	pytest -vv || die
}
