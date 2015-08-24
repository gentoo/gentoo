# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python Bindings for the Google Voice API"
HOMEPAGE="https://code.google.com/p/pygooglevoice/"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.gz
	https://${PN}.googlecode.com/files/${P}-extras.zip"

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
