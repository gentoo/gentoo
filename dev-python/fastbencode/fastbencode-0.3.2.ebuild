# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Implementation of bencode with optional fast C extensions"
HOMEPAGE="
	https://github.com/breezy-team/fastbencode/
	https://pypi.org/project/fastbencode/
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+native-extensions"

BDEPEND="
	native-extensions? (
		dev-python/cython[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

src_prepare() {
	distutils-r1_src_prepare

	# makes the extension non-optional (when built)
	export CIBUILDWHEEL=1
	if ! use native-extensions; then
		sed -i -e '/^add_cython_extension(/d' setup.py || die
	fi
}

src_test() {
	mv fastbencode/tests tests || die
	rm -r fastbencode || die

	distutils-r1_src_test
}
