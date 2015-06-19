# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pygene/pygene-0.2.1-r1.ebuild,v 1.1 2015/01/02 11:40:04 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Simple python genetic algorithms programming library"
HOMEPAGE="http://www.freenet.org.nz/python/pygene/"
SRC_URI="http://www.freenet.org.nz/python/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

DEPEND="doc? ( >=dev-python/epydoc-2.1-r2 )"
RDEPEND="examples? ( >=dev-python/pyfltk-1.1.2 )"

python_prepare_all() {
	if use examples; then
		mkdir examples || die
		mv demo*.py salesman.gif examples || die
	fi
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		epydoc -n "pygene - Python genetic algorithms" -o doc pygene \
		|| die "Generation of documentation failed"
	fi
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/. )
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
