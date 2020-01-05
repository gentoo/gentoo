# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_P=PyChart-${PV}

DESCRIPTION="Python library for creating charts"
HOMEPAGE="http://home.gna.org/pychart/"
SRC_URI="http://download.gna.org/pychart/${MY_P}.tar.gz
	doc? ( http://download.gna.org/pychart/${PN}-doc.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc x86"
IUSE="doc examples"

DEPEND="app-text/ghostscript-gpl"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

python_install_all() {
	use doc && local HTML_DOCS=( "${WORKDIR}"/${PN}/. )
	use examples && local EXAMPLES=( demos/. )

	distutils-r1_python_install_all
}
