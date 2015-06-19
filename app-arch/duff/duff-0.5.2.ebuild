# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/duff/duff-0.5.2.ebuild,v 1.1 2013/06/19 03:33:57 patrick Exp $

EAPI="5"

DESCRIPTION="Command-line utility for quickly finding duplicates in a given set of files"
HOMEPAGE="http://duff.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND=""
RDEPEND=""

src_install() {
	emake DESTDIR="${D}" install || die "Failed emake install"
	dodoc AUTHORS ChangeLog HACKING NEWS README* TODO
}
