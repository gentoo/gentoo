# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/scim-m17n/scim-m17n-0.2.2.ebuild,v 1.12 2011/02/13 19:16:13 armin76 Exp $

inherit eutils

DESCRIPTION="scim-m17n is an input module for Smart Common Input Method (SCIM) which uses m17n as backend"
HOMEPAGE="http://www.scim-im.org/projects/imengines"
SRC_URI="mirror://sourceforge/scim/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

DEPEND="|| ( >=app-i18n/scim-1.4 >=app-i18n/scim-cvs-1.4 )
	>=dev-libs/m17n-lib-1.2.0"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gcc43.patch
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	dodoc AUTHORS ChangeLog THANKS README
}

pkg_postinst() {
	elog
	elog "To use SCIM with both GTK2 and XIM, you should use the following"
	elog "in your user startup scripts such as .gnomerc or .xinitrc:"
	elog
	elog "LANG='your_language' scim -d"
	elog "export XMODIFIERS=@im=SCIM"
	elog "export GTK_IM_MODULE=\"scim\""
	elog
}
