# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils

DESCRIPTION="Japanese input method Tomoe IMEngine for SCIM"
HOMEPAGE="http://tomoe.sourceforge.net/"
SRC_URI="mirror://sourceforge/tomoe/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="|| ( >=app-i18n/scim-1.2.0 >=app-i18n/scim-cvs-1.2.0 )
	>=app-i18n/tomoe-gtk-0.6.0"

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	dodoc AUTHORS ChangeLog NEWS README TODO
}
