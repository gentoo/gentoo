# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy{,3} python{2_7,3_{5,6,7,8}} )

inherit distutils-r1

DESCRIPTION="Backport of pathlib-compatible object wrapper for zip files"
HOMEPAGE="https://github.com/jaraco/zipp"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="doc test"

RDEPEND="dev-python/more-itertools[${PYTHON_USEDEP}]"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		$(python_gen_cond_dep 'dev-python/contextlib2[${PYTHON_USEDEP}]' pypy{,3} python{2_7,3_{5,6,7}})
		$(python_gen_cond_dep 'dev-python/pathlib2[${PYTHON_USEDEP}]' pypy{,3} python{2_7,3_{5,6,7}})
		$(python_gen_cond_dep 'dev-python/unittest2[${PYTHON_USEDEP}]' pypy{,3} python{2_7,3_{5,6,7}})
	)
	doc? (
		$(python_gen_any_dep '
			>=dev-python/jaraco-packaging-3.2[${PYTHON_USEDEP}]
			>=dev-python/rst-linker-1.9[${PYTHON_USEDEP}]
			dev-python/sphinx[${PYTHON_USEDEP}]
		')
	)
"

distutils_enable_tests pytest

python_check_deps() {
	if use doc; then
		has_version ">=dev-python/jaraco-packaging-3.2[${PYTHON_USEDEP}]" || return ${?}
		has_version ">=dev-python/rst-linker-1.9[${PYTHON_USEDEP}]" || return ${?}
		has_version "dev-python/sphinx[${PYTHON_USEDEP}]" || return ${?}
	fi
}

python_prepare_all() {
	sed -i "s:use_scm_version=True:version='${PV}':" setup.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		sphinx-build docs docs/_build/html || die
		HTML_DOCS=( docs/_build/html/. )
	fi
}
