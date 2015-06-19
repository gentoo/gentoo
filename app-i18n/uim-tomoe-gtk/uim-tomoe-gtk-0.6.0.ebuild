# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/uim-tomoe-gtk/uim-tomoe-gtk-0.6.0.ebuild,v 1.2 2012/05/03 19:24:31 jdhore Exp $

DESCRIPTION="Japanese input method Tomoe IMEngine for uim"
HOMEPAGE="http://tomoe.sourceforge.net/"
SRC_URI="mirror://sourceforge/tomoe/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="|| ( app-i18n/uim app-i18n/uim-svn )
	>=app-i18n/libtomoe-gtk-0.6.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	dodoc AUTHORS ChangeLog NEWS README
}
