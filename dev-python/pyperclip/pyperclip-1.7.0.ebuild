# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7})
inherit distutils-r1 virtualx

DESCRIPTION="A cross-platform clipboard module for Python."
HOMEPAGE="https://github.com/asweigart/pyperclip"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	|| (
		x11-misc/xclip
		x11-misc/xsel
		dev-python/PyQt5[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/pygtk[${PYTHON_USEDEP}]' python2_7)
	)
"

python_prepare_all() {
	# make tests a proper module so setuptools can find the test suite
	touch tests/__init__.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	virtx esetup.py test
}
