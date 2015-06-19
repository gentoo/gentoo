# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xsri/xsri-2.1.0-r3.ebuild,v 1.3 2015/02/25 15:45:07 ago Exp $

EAPI=5
inherit autotools eutils rpm

DESCRIPTION="The xsri wallpaper setter from RedHat"
HOMEPAGE="http://fedoraproject.org"
SRC_URI="http://download.fedoraproject.org/pub/fedora/linux/releases/15/Everything/source/SRPMS/${P}-17.fc12.src.rpm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-fbsd"

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-configure.patch
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS README
	doman ../${PN}.1
}
