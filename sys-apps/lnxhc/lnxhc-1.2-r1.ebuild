# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/lnxhc/lnxhc-1.2-r1.ebuild,v 1.3 2013/07/04 12:24:08 ago Exp $

EAPI=5

inherit eutils
DESCRIPTION="Linux Health Checker"
HOMEPAGE="http://lnxhc.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-lang/perl-5.8"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.2-usrlocal.patch"
	epatch "${FILESDIR}/${PN}-1.2-ifconfig-path.patch"
}
