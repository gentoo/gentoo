# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{3_5,3_6,3_7} )

inherit distutils-r1 virtualx

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
	>=dev-python/colorama-0.3.7[${PYTHON_USEDEP}]
	>=dev-python/pyperclip-1.6[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/wcwidth[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

python_test() {
	# test rely on very specific text wrapping...
	local -x COLUMNS=80
	pytest -vv || die
}

src_test() {
	virtx distutils-r1_src_test
}
