# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A simple and Pythonic XML template language"
HOMEPAGE="http://www.kid-templating.org/ https://pypi.python.org/pypi/kid"
SRC_URI="http://www.kid-templating.org/dist/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ia64 x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="doc examples test"

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/docutils[${PYTHON_USEDEP}] )"

DOCS=( README doc/{guide.txt,index.txt,notes.txt} )

python_compile_all() {
	use doc && emake -C doc
}

python_test() {
	py.test -xl || die
}

python_install_all() {
#	dobin bin/*

	use doc && local HTML_DOCS=( doc/html/. )
	use examples && local EXAMPLES=( examples/. )

	distutils-r1_python_install_all
}
