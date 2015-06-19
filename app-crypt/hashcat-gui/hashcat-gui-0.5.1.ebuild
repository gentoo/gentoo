# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/hashcat-gui/hashcat-gui-0.5.1.ebuild,v 1.6 2013/03/02 19:14:06 hwoarang Exp $

EAPI=4

inherit qt4-r2

DESCRIPTION="A gui for the *hashcat* suite of tools"
HOMEPAGE="https://github.com/scandium/hashcat-gui"

SRC_URI="mirror://github/scandium/hashcat-gui/zipball/b6b01be723742ad89ba31fdb2c30b35306318f8b -> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="cuda opencl"

RDEPEND="app-crypt/hashcat-bin
	cuda? ( app-crypt/oclhashcat-plus-bin
	app-crypt/oclhashcat-lite-bin )
	opencl? ( app-crypt/oclhashcat-plus-bin
	app-crypt/oclhashcat-lite-bin )
	dev-qt/qtgui:4
	dev-qt/qtcore:4"

DEPEND="dev-qt/qtgui:4
	dev-qt/qtcore:4
	app-arch/unzip"

S="${WORKDIR}"/scandium-hashcat-gui-b6b01be/src

src_prepare() {
	sed -i 's#./hashcat#/opt/hashcat-bin#g' mainwindow.cpp || die
	sed -i 's#./oclHashcat-plus#/opt/oclhashcat-plus-bin#g' mainwindow.cpp || die
	sed -i 's#./oclHashcat-lite#/opt/oclhashcat-lite-bin#g' mainwindow.cpp || die
}

src_install() {
	dobin hashcat-gui
	cd "${WORKDIR}"/scandium-hashcat-gui-b6b01be || die
	dodoc ChangeLog FAQ INSTALL README TODO
}
