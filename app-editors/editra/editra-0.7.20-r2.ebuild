# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit eutils distutils-r1 fdo-mime

MY_PN=${PN/e/E}

DESCRIPTION="Multi-platform text editor supporting over 50 programming languages"
HOMEPAGE="http://editra.org https://pypi.python.org/pypi/Editra"
SRC_URI="http://editra.org/uploads/src/${MY_PN}-${PV}.tar.gz"

LICENSE="wxWinLL-3.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="spell"

DEPEND="
	dev-python/wxpython:3.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools-0.6[${PYTHON_USEDEP}]"
# setuptools is RDEPEND because it's used by the runtime for installing plugins
RDEPEND="${DEPEND}
	spell? ( dev-python/pyenchant[${PYTHON_USEDEP}] )"

PATCHES=( "${FILESDIR}/${P}-wx30.patch" )

S="${WORKDIR}"/${MY_PN}-${PV}

python_compile() {
	# https://code.google.com/p/editra/issues/detail?id=481
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
