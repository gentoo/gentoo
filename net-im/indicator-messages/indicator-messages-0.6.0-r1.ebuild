# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/indicator-messages/indicator-messages-0.6.0-r1.ebuild,v 1.1 2015/04/05 16:09:44 mgorny Exp $

EAPI=4
inherit eutils gnome2-utils

DESCRIPTION="A place on the user's desktop that collects messages that need a response"
HOMEPAGE="http://launchpad.net/indicator-messages"
SRC_URI="http://launchpad.net/${PN}/${PV%.*}/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/libdbusmenu-0.6.2[gtk3]
	>=dev-libs/glib-2.22
	>=dev-libs/libindicate-12.10.0:3
	>=dev-libs/libindicator-12.10.0:3
	net-libs/telepathy-glib
	>=x11-libs/gtk+-3.2:3"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

src_configure() {
	econf \
		--disable-silent-rules \
		--with-gtk=3
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog
	prune_libtool_files --all
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
