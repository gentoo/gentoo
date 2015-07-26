# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/leo/leo-5.1.ebuild,v 1.2 2015/07/23 20:59:04 pacho Exp $

EAPI=5

# Not py3 prepared
# https://bugs.launchpad.net/leo-editor/+bug/1399895
PYTHON_COMPAT=( python2_7 )
PYTHON_REQUIRED_USE="tk"

inherit distutils-r1

MY_P="Leo-${PV}-final"

DESCRIPTION="Leo: Literate Editor with Outlines"
HOMEPAGE="https://github.com/leo-editor/leo-editor/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ppc ~x86"
IUSE="doc"

RDEPEND="app-text/silvercity[${PYTHON_USEDEP}]
	dev-python/PyQt4[X,${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/${MY_P}"

python_install_all() {
	use doc && local HTML_DOCS=( leo/doc/html/. )
	distutils-r1_python_install_all
}
