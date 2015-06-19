# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/daemontools-encore/daemontools-encore-1.10.ebuild,v 1.1 2014/09/22 08:36:39 polynomial-c Exp $

EAPI=5

inherit flag-o-matic qmail

DESCRIPTION="Collection of tools for managing UNIX services"
HOMEPAGE="http://untroubled.org/daemontools-encore/"
SRC_URI="http://untroubled.org/daemontools-encore/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="selinux static"

DEPEND=""
RDEPEND="selinux? ( sec-policy/selinux-daemontools )
	!sys-process/daemontools
	!app-doc/daemontools-man"

src_compile() {
	use static && append-ldflags -static
	qmail_set_cc
	emake
}

src_install() {
	keepdir /service

	echo ${D}/usr/bin >conf-bin
	echo ${D}/usr/share/man >conf-man
	dodir /usr/bin
	dodir /usr/share/man
	emake install

	dodoc ChangeLog CHANGES CHANGES.djb README TODO

	newinitd "${FILESDIR}"/svscan.init-2 svscan
}

pkg_postinst() {
	einfo
	einfo "You can run daemontools using the svscan init.d script,"
	einfo "or you could run it through inittab."
	einfo "To use inittab, emerge supervise-scripts and run:"
	einfo "svscan-add-to-inittab"
	einfo "Then you can hup init with the command telinit q"
	einfo
}
