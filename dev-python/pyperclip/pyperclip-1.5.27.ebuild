# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6..8} )
inherit distutils-r1 virtualx

DESCRIPTION="A cross-platform clipboard module for Python."
HOMEPAGE="https://github.com/asweigart/pyperclip"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 x86"

RDEPEND="
	|| (
		x11-misc/xclip
		x11-misc/xsel
		dev-python/PyQt5[${PYTHON_USEDEP}]
	)
"

python_test() {
	"${EPYTHON}" tests/test_copy_paste.py -vv ||
		die "Tests fail on ${EPYTHON}"
}

src_test() {
	virtx distutils-r1_src_test
}
