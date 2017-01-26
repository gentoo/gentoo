# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} )
PYTHON_REQ_USE="ncurses"

inherit distutils-r1

DESCRIPTION="Urwid is a curses-based user interface library for Python"
HOMEPAGE="http://urwid.org/ https://pypi.python.org/pypi/urwid/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ia64 ~mips ppc ppc64 ~sparc x86 ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="doc examples test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/twisted-core )"

PATCHES=( "${FILESDIR}"/${PN}-1.1.0-sphinx.patch )

python_compile_all() {
	if use doc ; then
		if [[ ${EPYTHON} == python3* ]] ; then
			2to3 -nw --no-diffs docs/conf.py || die
		fi
		cd docs
		sphinx-build . _build/html || die
	fi
}

python_compile() {
	if [[ ${EPYTHON} == python2* ]] ; then
		local CFLAGS="${CFLAGS} -fno-strict-aliasing"
		export CFLAGS
	fi

	distutils-r1_python_compile
}

python_test() {
	esetup.py test
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	use doc && local HTML_DOCS=( docs/_build/html/. )

	distutils-r1_python_install_all
}
