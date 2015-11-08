# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Grub menu entries for the .iso image of systemrescuecd-x86"
HOMEPAGE="http://www.sysresccd.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT=0
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}

RDEPEND="app-admin/systemrescuecd-x86
	sys-boot/grub"

src_install() {
	exeinto /etc/grub.d
	newexe "${FILESDIR}"/systemrescuecd.grub 39_systemrescuecd

	insinto /etc/default
	newins "${FILESDIR}"/systemrescuecd.default systemrescuecd
}

pkg_postinst() {
	elog "To add the menu entries for systemrescuecd to grub, you should now run"
	elog "	grub-mkconfig -o /boot/grub/grub.cfg"
	elog "You can set custom bootoptions in /etc/default/systemrescuecd"
}
