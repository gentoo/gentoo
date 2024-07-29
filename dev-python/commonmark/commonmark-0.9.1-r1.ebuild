# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Python parser for the CommonMark Markdown spec"
HOMEPAGE="
	https://pypi.org/project/commonmark/
	https://github.com/readthedocs/commonmark.py/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		>=dev-python/hypothesis-3.7.1[${PYTHON_USEDEP}]
	)
"

python_test() {
	local -x PYTHONIOENCODING='utf8'
	"${EPYTHON}" commonmark/tests/run_spec_tests.py || die
}

src_prepare() {
	default
	# Fix file collision with app-text/cmark, see bug #627034
	sed -i -e "s:'cmark\( = commonmark.cmark\:main'\):'cmark.py\1:" \
		setup.py || die
}

pkg_postinst() {
	ewarn "/usr/bin/cmark has been renamed to /usr/bin/cmark.py due file"
	ewarn "collision with app-text/cmark (see bug #627034)"
}
