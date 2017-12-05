# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Emulates scrollwheel, right- & left-click for one-button mice/touchpads"
HOMEPAGE="http://geekounet.org/powerbook/"
SRC_URI="http://geekounet.org/powerbook/files/${PN}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ppc"
IUSE=""

DEPEND=""

S=${WORKDIR}/${PN}
PATCHES=( "${FILESDIR}"/${P}-fix.diff )

src_install() {
	dosbin mouseemu
	einstalldocs

	newinitd mouseemu.init.gentoo mouseemu
	insinto /etc
	doins mouseemu.conf
}

pkg_postinst() {
	einfo "For mouseemu to work you need uinput support in your kernel:"
	einfo "        CONFIG_INPUT_UINPUT=y"
	einfo "(Device Drivers->Input device support->Misc->User level driver support)"
	einfo "Don't forget to add mouseemu to your default runlevel:"
	einfo "        rc-update add mouseemu default"
	einfo "Configuration is in /etc/mouseemu.conf."
}
