# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/scim-anthy/scim-anthy-1.3.1.ebuild,v 1.6 2012/09/26 03:23:09 naota Exp $

EAPI="2"

inherit libtool

DESCRIPTION="Japanese input method Anthy IMEngine for SCIM"
HOMEPAGE="http://scim-imengine.sourceforge.jp/index.cgi?cmd=view;name=SCIMAnthy"
SRC_URI="mirror://sourceforge.jp/scim-imengine/29660/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE="gtk nls"

DEPEND=">=app-i18n/scim-1.2[-gtk3]
	|| ( >=app-i18n/anthy-7500 >=app-i18n/anthy-ss-7500 )
	nls? ( virtual/libintl )
	gtk? ( >=x11-libs/gtk+-2.8:2 )"
RDEPEND="${DEPEND}
	gtk? ( app-dicts/kasumi )"
DEPEND="${DEPEND}
	nls? ( sys-devel/gettext )
	virtual/pkgconfig"

src_prepare() {
	elibtoolize
}

src_configure() {
	econf \
		$(use_enable nls) \
		--disable-static \
		--disable-dependency-tracking || die
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README
}

pkg_postinst() {
	elog
	elog "To use SCIM, you should use the following in your user startup scripts"
	elog "such as .gnomerc or .xinitrc:"
	elog
	elog "LANG='your_language' scim -d"
	elog "export XMODIFIERS=@im=SCIM"
	elog "export GTK_IM_MODULE=scim"
	elog "export QT_IM_MODULE=scim"
	elog
}
