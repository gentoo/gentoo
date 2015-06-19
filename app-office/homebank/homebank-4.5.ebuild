# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/homebank/homebank-4.5.ebuild,v 1.5 2014/02/08 12:08:34 pacho Exp $

EAPI="4"

inherit fdo-mime eutils

DESCRIPTION="Free, easy, personal accounting for everyone"
HOMEPAGE="http://homebank.free.fr/index.php"
SRC_URI="http://homebank.free.fr/public/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE="+ofx"
KEYWORDS="amd64 ppc x86"

RDEPEND=">=x11-libs/gtk+-2.20:2
	>=dev-libs/glib-2.17
	ofx? ( >=dev-libs/libofx-0.7 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-util/intltool-0.40.5"

src_configure() {
	econf $(use_with ofx)
}

src_install() {
	emake DESTDIR="${D}" install || die "Installation failed"
	dodoc AUTHORS ChangeLog README
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
