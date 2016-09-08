# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit gnome2

DESCRIPTION="A clone of the popular board game The Settlers of Catan"
HOMEPAGE="http://pio.sourceforge.net/"
SRC_URI="mirror://sourceforge/pio/${P}.tar.gz"

LICENSE="GPL-2 CC-BY-SA-4.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="dedicated help nls"

# dev-util/gob only for autoreconf
RDEPEND=">=dev-libs/glib-2.26:2
	!dedicated?	(
		>=x11-libs/gtk+-3.4:3
		>=x11-libs/libnotify-0.7.4
		help? (
			app-text/rarian
			>=gnome-base/libgnome-2.10
		)
	)
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	dev-util/gob:2
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable nls) \
		$(use_enable help) \
		--includedir=/usr/include \
		$(use_with !dedicated gtk)
}

src_install() {
	DOCS='AUTHORS ChangeLog README TODO NEWS' \
		gnome2_src_install scrollkeeper_localstate_dir="${ED%/}"/var/lib/scrollkeeper/
}
