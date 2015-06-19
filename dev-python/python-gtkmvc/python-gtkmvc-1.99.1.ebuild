# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-gtkmvc/python-gtkmvc-1.99.1.ebuild,v 1.4 2015/04/08 08:05:01 mgorny Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="model-view-controller (MVC) implementation for pygtk"
HOMEPAGE="http://pygtkmvc.sourceforge.net/"
SRC_URI="mirror://sourceforge/pygtkmvc/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc examples"

DEPEND=""
RDEPEND=">=dev-python/pygtk-2.24.0"

python_compile_all() {
	use doc && emake -C docs html
}

python_install_all() {
	dodoc README
	use doc && dohtml -r docs/_build/html/

	if use examples; then
		docompress -x usr/share/doc/${P}/examples/
		insinto usr/share/doc/${P}/
		doins -r examples/
	fi
}
