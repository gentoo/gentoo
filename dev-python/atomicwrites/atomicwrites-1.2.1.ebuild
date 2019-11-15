# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( pypy{,3} python{2_7,3_{5,6,7,8}} )

inherit distutils-r1

DESCRIPTION="Atomic file writes"
HOMEPAGE="https://github.com/untitaker/python-atomicwrites"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~x86 ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc"

# TODO: remove impl limiters when sphinx is py38
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		$(python_gen_any_dep '
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
		' -2 python3_{5,6,7} pypy3)
	)
"

distutils_enable_tests pytest

python_check_deps() {
	use doc || return 0
	has_version "dev-python/sphinx[${PYTHON_USEDEP}]" &&
		has_version "dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]"
}

python_prepare_all() {
	sed -i "/'sphinx.ext.intersphinx'/d" docs/conf.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		sphinx-build docs docs/_build/html || die
		HTML_DOCS=( docs/_build/html/. )
	fi
}
