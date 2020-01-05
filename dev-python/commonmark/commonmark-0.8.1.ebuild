# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6,3_7} )

inherit distutils-r1

DESCRIPTION="Python parser for the CommonMark Markdown spec"
HOMEPAGE="https://github.com/rtfd/CommonMark-py"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/future[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		>=dev-python/hypothesis-3.7.1[${PYTHON_USEDEP}]
	)
	dev-python/setuptools[${PYTHON_USEDEP}]
"

python_test() {
	PYTHONIOENCODING='utf8' \
	esetup.py test
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
