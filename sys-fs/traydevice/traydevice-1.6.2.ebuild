# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/traydevice/traydevice-1.6.2.ebuild,v 1.3 2013/05/11 21:44:49 floppym Exp $

EAPI=5

PYTHON_DEPEND="2:2.6"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.5 3.*"

inherit distutils

DESCRIPTION="A little desktop application displaying systray icon for UDisks"
HOMEPAGE="http://savannah.nongnu.org/projects/traydevice/"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/dbus-python
	dev-python/lxml
	dev-python/pyxdg
	sys-fs/udisks:2"
DEPEND="app-text/docbook2X"

src_compile() { :; }

src_install() {
	distutils_src_install \
		--prefix=/usr \
		--install-data=/usr/share/${PN} \
		--install-man=/usr/share/man \
		--docbook2man=$(type -p docbook2man.pl)

	rm -f "${D}"/usr/share/${PN}/*.txt
}
