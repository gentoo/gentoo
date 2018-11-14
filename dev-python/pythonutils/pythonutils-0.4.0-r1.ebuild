# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Voidspace Python modules"
HOMEPAGE="http://www.voidspace.org.uk/python/pythonutils.html"
SRC_URI="http://www.voidspace.org.uk/downloads/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="app-arch/unzip"
RDEPEND=""

python_install_all() {
	dodoc docs/*.txt
	use doc && local HTML_DOCS=( docs/. )
	distutils-r1_python_install_all
}
