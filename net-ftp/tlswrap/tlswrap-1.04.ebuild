# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="TLSWRAP is a TLS/SSL FTP wrapper/proxy which allows to use TLS with every FTP client"
HOMEPAGE="http://tlswrap.sunsite.dk"
SRC_URI="http://tlswrap.sunsite.dk/${P}.tar.gz"

# GPL-2 for Gentoo init script
LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-libs/openssl-0.9.7"
RDEPEND=${DEPEND}

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	dodoc ChangeLog README
	# einstall for sandbox issues
	einstall || die "einstall failed"
	newinitd "${FILESDIR}/tlswrap.init" tlswrap
}
