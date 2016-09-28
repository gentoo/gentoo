# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{3,4,5} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="A Python package for creating beautiful command line interfaces"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"
HOMEPAGE="http://click.pocoo.org/ https://pypi.python.org/pypi/click"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"
IUSE="doc examples test"

REQUIRED_USE="doc? ( || ( $(python_gen_useflags 'python2*') ) )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

pkg_setup() {
	use doc && DISTUTILS_ALL_SUBPHASE_IMPLS=( 'python2*' )
}

python_prepare_all() {
	# Prevent un-needed d'loading
	sed -e "s/, 'sphinx.ext.intersphinx'//" -i docs/conf.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	emake test
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
