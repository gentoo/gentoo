# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-laptop/thinkfan/thinkfan-0.8.1-r1.ebuild,v 1.3 2013/02/04 13:18:04 ago Exp $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="simple fan control program for thinkpads"
HOMEPAGE="http://thinkfan.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-openrc.patch
	tc-export CC
}

src_install() {
	dosbin ${PN}

	newinitd rcscripts/thinkfan.gentoo ${PN}

	doman ${PN}.1
	dodoc ChangeLog NEWS README \
		examples/${PN}.conf.{complex,sysfs,thinkpad}
}

pkg_postinst() {
	elog "Please read the documentation and copy an"
	elog "appropriate file to /etc/thinkfan.conf."
}
