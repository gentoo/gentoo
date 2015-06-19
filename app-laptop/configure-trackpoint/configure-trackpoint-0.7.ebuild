# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-laptop/configure-trackpoint/configure-trackpoint-0.7.ebuild,v 1.5 2015/06/04 18:59:39 kensington Exp $

EAPI=5
GCONF_DEBUG="no"

inherit gnome2 readme.gentoo

DESCRIPTION="Thinkpad GNOME configuration utility for TrackPoint (For the linux
kernel 2.6 TrackPoint driver)"
HOMEPAGE="http://tpctl.sourceforge.net/configure-trackpoint.html"
SRC_URI="mirror://sourceforge/tpctl/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-laptop/tp_smapi
	>=x11-libs/gtk+-2.2:2
	|| ( x11-libs/gksu kde-apps/kdesu )
	>=gnome-base/libgnomeui-2.4
	>=sys-devel/gettext-0.11"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	DOC_CONTENTS="The ${PN} does not automatically load the app-laptop/tp_smapi modules
		so you need to do it manually"

	if has_version kde-apps/kdesu && ! has_version x11-libs/gksu; then
		sed -i -e "/^Exec/s:gksu:kdesu:" ${PN}.desktop \
			|| die "Failed to replace gksu with kdesu"
	fi
	gnome2_src_prepare
}

src_install() {
	gnome2_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	gnome2_pkg_postinst
	readme.gentoo_print_elog
}
