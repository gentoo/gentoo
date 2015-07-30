# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/homebank/homebank-5.0.3.ebuild,v 1.1 2015/07/30 17:23:35 calchan Exp $

EAPI="5"

inherit fdo-mime eutils

DESCRIPTION="Free, easy, personal accounting for everyone"
HOMEPAGE="http://homebank.free.fr/index.php"
SRC_URI="http://homebank.free.fr/public/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE="+ofx"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=">=dev-libs/glib-2.28
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	>=x11-libs/gtk+-3.6.4:3
	x11-libs/pango
	ofx? ( >=dev-libs/libofx-0.8.3 )"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5.8.1
	dev-perl/XML-Parser
	>=dev-util/intltool-0.40.5
	sys-devel/gettext
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog README )

src_configure() {
	econf $(use_with ofx)
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
