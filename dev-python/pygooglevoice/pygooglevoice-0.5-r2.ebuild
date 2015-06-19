# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pygooglevoice/pygooglevoice-0.5-r2.ebuild,v 1.1 2015/01/02 23:18:33 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python Bindings for the Google Voice API"
HOMEPAGE="http://code.google.com/p/pygooglevoice/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz
	http://${PN}.googlecode.com/files/${P}-extras.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

DEPEND="app-arch/unzip"

# Requires interactive login
RESTRICT="test"

PATCH=( "${FILESDIR}"/${P}-auth.patch )

python_test() {
	"${PYTHON}" googlevoice/tests.py
}

python_install_all() {
	use doc && local HTML_DOCS=( "${WORKDIR}"/doc/. )
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
