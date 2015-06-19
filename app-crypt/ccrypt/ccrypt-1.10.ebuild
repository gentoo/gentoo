# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/ccrypt/ccrypt-1.10.ebuild,v 1.1 2012/12/19 07:04:39 alonbl Exp $

EAPI="3"

DESCRIPTION="Encryption and decryption"
HOMEPAGE="http://ccrypt.sourceforge.net"
SRC_URI="http://ccrypt.sourceforge.net/download/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

src_install () {
	emake \
		DESTDIR="${D}" \
		htmldir="${EPREFIX}/usr/share/doc/${PF}" \
		install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
