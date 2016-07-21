# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Japanese input method Wnn IMEngine for SCIM"
HOMEPAGE="http://nop.net-p.org/modules/pukiwiki/index.php?%5B%5Bscim-wnn%5D%5D"
SRC_URI="http://nop.net-p.org/files/scim-wnn/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="freewnn"

RDEPEND="|| ( >=app-i18n/scim-1.0 >=app-i18n/scim-cvs-1.0 )
	dev-libs/wnn7sdk
	freewnn? ( app-i18n/freewnn )"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd "${S}"/src
	sed -i -e "s:/usr/lib/wnn7:/usr/lib/wnn:g" \
		scim_wnn_def.h wnnconversion.cpp || die "sed failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	dodoc AUTHORS THANKS README
}

pkg_postinst() {
	elog
	elog "To use SCIM with both GTK2 and XIM, you should use the following"
	elog "in your user startup scripts such as .gnomerc or .xinitrc:"
	elog
	elog "LANG='your_language' scim -d"
	elog "export XMODIFIERS=@im=SCIM"
	elog
	if ! use freewnn ; then
	ewarn
	ewarn "You disabled freewnn USE flag."
	ewarn "Please make sure you have wnnenvrc visible to scim-wnn."
	ewarn
	fi
}
