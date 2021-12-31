# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7,8} pypy{,3} )

inherit distutils-r1

DESCRIPTION="More routines for operating on iterables, beyond itertools"
HOMEPAGE="https://pypi.org/project/more-itertools/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		$(python_gen_any_dep '
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
		')
	)
"

distutils_enable_tests unittest

python_check_deps() {
	use doc || return 0
	has_version "dev-python/sphinx[${PYTHON_USEDEP}]" &&
		has_version "dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]"
}

python_compile_all() {
	if use doc; then
		sphinx-build docs docs/_build/html || die
		HTML_DOCS=( docs/_build/html/. )
	fi
}
