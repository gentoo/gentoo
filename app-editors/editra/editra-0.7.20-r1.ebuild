# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/editra/editra-0.7.20-r1.ebuild,v 1.3 2015/08/06 07:21:52 ago Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils fdo-mime

MY_PN=${PN/e/E}

DESCRIPTION="Multi-platform text editor supporting over 50 programming languages"
HOMEPAGE="http://editra.org http://pypi.python.org/pypi/Editra"
SRC_URI="http://editra.org/uploads/src/${MY_PN}-${PV}.tar.gz"

LICENSE="wxWinLL-3.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="spell"

DEPEND="
	>=dev-python/wxpython-2.8.9.2:2.8[${PYTHON_USEDEP}]
	>=dev-python/setuptools-0.6[${PYTHON_USEDEP}]"
# setuptools is RDEPEND because it's used by the runtime for installing plugins
RDEPEND="${DEPEND}
	spell? ( dev-python/pyenchant[${PYTHON_USEDEP}] )"

S="${WORKDIR}"/${MY_PN}-${PV}

python_compile() {
	# http://code.google.com/p/editra/issues/detail?id=481
	distutils-r1_python_compile --no-clean
}

python_install() {
	distutils-r1_python_install --no-clean
}

python_install_all() {
	distutils-r1_python_install_all

	doicon "${S}"/pixmaps/editra.png
	make_desktop_entry editra Editra editra "Utility;TextEditor"
	dodoc FAQ THANKS
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
