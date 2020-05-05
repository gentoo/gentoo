# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Python parser for the CommonMark Markdown spec"
HOMEPAGE="https://github.com/readthedocs/commonmark.py"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ppc ppc64 sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		>=dev-python/hypothesis-3.7.1[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests setup.py

src_test() {
	local -x PYTHONIOENCODING='utf8'
	distutils-r1_src_test
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
