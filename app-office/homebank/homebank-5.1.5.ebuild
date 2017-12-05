# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit xdg-utils eutils gnome2-utils

DESCRIPTION="Free, easy, personal accounting for everyone"
HOMEPAGE="http://homebank.free.fr/index.php"
SRC_URI="http://homebank.free.fr/public/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE="+ofx"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=">=dev-libs/glib-2.39
	>=net-libs/libsoup-2.26
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	>=x11-libs/gtk+-3.12:3
	x11-libs/pango
	ofx? ( >=dev-libs/libofx-0.8.3 )"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5.8.1
	dev-perl/XML-Parser
	>=dev-util/intltool-0.40.5
	sys-devel/gettext
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog README )

src_prepare(){
	echo src/hb-payee.c >> po/POTFILES.in || die
	eapply_user
}

src_configure() {
	econf $(use_with ofx)
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}
