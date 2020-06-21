# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1 virtualx

DESCRIPTION="Extra features for standard library's cmd module"
HOMEPAGE="https://github.com/python-cmd2/cmd2"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.3.7[${PYTHON_USEDEP}]
	>=dev-python/pyperclip-1.6[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/wcwidth[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? ( dev-python/pytest-mock[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e 's:test_which_editor_good:_&:' tests/test_cmd2.py || die
	distutils-r1_src_prepare
}

src_test() {
	# tests rely on very specific text wrapping...
	local -x COLUMNS=80
	virtx distutils-r1_src_test
}

python_test() {
	distutils_install_for_testing
	pytest -vv || die "Tests failed with ${EPYTHON}"
}
