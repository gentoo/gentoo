# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools

DESCRIPTION="GTK GUI for Connman"
HOMEPAGE="https://github.com/jgke/connman-gtk"
SRC_URI="https://github.com/jgke/connman-gtk/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="openconnect"

CDEPEND="
	>=dev-libs/glib-2.0:2
	>=x11-libs/gtk+-3.10:3
	openconnect? ( >=net-vpn/openconnect-5.99 )
"
RDEPEND="${CDEPEND}
	net-misc/connman
"
DEPEND="${CDEOEND}
	>=dev-util/intltool-0.35.0
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		$(use_with openconnect)
}
