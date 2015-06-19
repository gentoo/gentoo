# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/traydevice/traydevice-1.5.ebuild,v 1.6 2012/03/27 18:41:32 ssuominen Exp $

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="A little desktop application displaying systray icon for UDisks"
HOMEPAGE="http://savannah.nongnu.org/projects/traydevice/"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-python/dbus-python
	dev-python/lxml
	dev-python/pyxdg
	sys-fs/udisks:0"
DEPEND="app-text/docbook2X"

src_prepare() {
	sed -i \
		-e 's:docbook2man:docbook2man.pl:' \
		setup.py || die

	distutils_src_prepare
}

src_compile() { :; }

src_install() {
	distutils_src_install \
		--root="${D}" \
		--prefix=/usr \
		--install-data=/usr/share/${PN} \
		--install-man=/usr/share/man

	rm -f "${D}"/usr/share/${PN}/*.txt
}
