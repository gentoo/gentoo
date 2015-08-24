# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
SUPPORT_PYTHON_ABIS=1
PYTHON_DEPEND="2:2.6"
RESTRICT_PYTHON_ABIS="2.5 3.* *-jython 2.7-pypy-*"

inherit distutils eutils fdo-mime python

MY_PN=${PN/e/E}

DESCRIPTION="Multi-platform text editor supporting over 50 programming languages"
HOMEPAGE="http://editra.org https://pypi.python.org/pypi/Editra"
SRC_URI="http://editra.org/uploads/src/${MY_PN}-${PV}.tar.gz"

LICENSE="wxWinLL-3.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="spell"

DEPEND=">=dev-python/wxpython-2.8.9.2:2.8
		>=dev-python/setuptools-0.6"
# setuptools is RDEPEND because it's used by the runtime for installing plugins
RDEPEND="${DEPEND}
	spell? ( dev-python/pyenchant )"

S="${WORKDIR}"/${MY_PN}-${PV}

src_compile() {
	distutils_src_compile --no-clean # https://code.google.com/p/editra/issues/detail?id=481
}

src_install() {
	distutils_src_install --no-clean
	doicon "${S}"/pixmaps/editra.png
	make_desktop_entry editra Editra editra "Utility;TextEditor"
	dodoc FAQ THANKS
}

pkg_postinst() {
	distutils_pkg_postinst
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	distutils_pkg_postrm
	fdo-mime_desktop_database_update
}
