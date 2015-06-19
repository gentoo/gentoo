# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gmpc-mmkeys/gmpc-mmkeys-11.8.16.ebuild,v 1.6 2013/04/14 12:22:24 angelos Exp $

EAPI=4
inherit vala

DESCRIPTION="Bind multimedia keys via gnome settings daemon"
HOMEPAGE="http://gmpc.wikia.com/wiki/Plugins"
SRC_URI="http://download.sarine.nl/Programs/gmpc/11.8/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-libs/dbus-glib
	>=media-sound/gmpc-${PV}"
DEPEND="${RDEPEND}
	$(vala_depend)
	virtual/pkgconfig"

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -name "*.la" -exec rm {} + || die
}
