# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/pyhoca-gui/pyhoca-gui-0.5.0.4-r1.ebuild,v 1.1 2015/02/19 09:35:42 voyageur Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="X2Go graphical client applet"
HOMEPAGE="http://www.x2go.org"
SRC_URI="http://code.x2go.org/releases/source/${PN}/${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/notify-python[${PYTHON_USEDEP}]
	dev-python/pycups[${PYTHON_USEDEP}]
	dev-python/setproctitle[${PYTHON_USEDEP}]
	dev-python/wxpython[${PYTHON_USEDEP}]
	>=net-misc/python-x2go-0.5.0.0[${PYTHON_USEDEP}]"
DEPEND="${DEPEND}
	dev-python/python-distutils-extra[${PYTHON_USEDEP}]"

python_install() {
	distutils-r1_python_install
	python_doscript ${PN}
}

python_install_all() {
	distutils-r1_python_install_all
	doman man/man1/*
}
