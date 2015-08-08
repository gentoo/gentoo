# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# Not py3 prepared
# https://bugs.launchpad.net/leo-editor/+bug/1399895
PYTHON_COMPAT=( python2_7 )
PYTHON_REQUIRED_USE="tk"

inherit distutils-r1

MY_P="Leo-${PV}-final"
MY_PN="Leo${PV}-final"

DESCRIPTION="Leo: Literate Editor with Outlines"
HOMEPAGE="https://github.com/leo-editor/leo-editor/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc"

RDEPEND="app-text/silvercity[${PYTHON_USEDEP}]
	dev-python/PyQt4[X,${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/${MY_PN}"

python_install_all() {
	use doc && local HTML_DOCS=( leo/doc/html/. )
	distutils-r1_python_install_all
}
