# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Simple, fast, extensible JSON encoder/decoder for Python"
HOMEPAGE="
	https://github.com/simplejson/simplejson/
	https://pypi.org/project/simplejson/
"

LICENSE="|| ( MIT AFL-2.1 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="+native-extensions"

DOCS=( README.rst CHANGES.txt )

distutils_enable_tests unittest

src_configure() {
	# native-extensions are always disabled on PyPy
	# https://github.com/simplejson/simplejson/blob/master/setup.py#L121
	export DISABLE_SPEEDUPS=$(usex native-extensions 0 1)
	use native-extensions && export REQUIRE_SPEEDUPS=1
}

python_test() {
	cd "${BUILD_DIR}/install$(python_get_sitedir)" || die
	eunittest
}
