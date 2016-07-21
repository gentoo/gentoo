# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils

DESCRIPTION="A simple client for DWUN"
HOMEPAGE="http://dwun.sourceforge.net/"
SRC_URI="mirror://sourceforge/dwun/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="net-dialup/dwun"

src_prepare() {
	epatch "${FILESDIR}/${P}-gcc3.3.patch"
}

src_install() {
	einstall || die "install failed."
	dodoc AUTHORS ChangeLog README TODO
}
