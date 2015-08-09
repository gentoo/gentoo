# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="A little desktop application displaying systray icon for UDisks"
HOMEPAGE="http://savannah.nongnu.org/projects/traydevice/"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	sys-fs/udisks:2"
DEPEND="app-text/docbook2X"

src_compile() { :; }

python_install() {
	distutils-r1_python_install \
		--prefix=/usr \
		--install-data=/usr/share/${PN} \
		--install-man=/usr/share/man \
		--docbook2man=docbook2man.pl
}

python_install_all() {
	distutils-r1_python_install_all
	rm -f "${ED}"/usr/share/${PN}/doc/*.txt
}
