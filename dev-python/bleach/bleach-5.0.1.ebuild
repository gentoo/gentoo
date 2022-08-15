# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="An easy whitelist-based HTML-sanitizing tool"
HOMEPAGE="
	https://github.com/mozilla/bleach/
	https://pypi.org/project/bleach/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/html5lib-1.0.1-r1[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/bleach-4.1.0-py39.patch
)

src_prepare() {
	# unbundle unpatched broken html5lib
	rm -r bleach/_vendor || die
	sed -i -e 's:bleach\._vendor\.parse:urllib.parse:' \
		bleach/parse_shim.py || die
	sed -i -e 's:bleach\._vendor\.::' \
		bleach/html5lib_shim.py \
		bleach/sanitizer.py \
		tests/test_clean.py || die
	# indirect html5lib deps
	sed -i -e '/six/d' -e '/webencodings/d' setup.py || die

	distutils-r1_src_prepare
}
