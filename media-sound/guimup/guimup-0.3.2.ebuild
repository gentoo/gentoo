# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/guimup/guimup-0.3.2.ebuild,v 1.2 2014/08/10 21:06:48 slyfox Exp $

EAPI=4

inherit eutils

MY_P=${P/-/_}

DESCRIPTION="A client for MPD with a clean, GTK interface"
HOMEPAGE="http://coonsden.com"
SRC_URI="mirror://sourceforge/musicpd/${MY_P}_src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DOCS="ChangeLog README NEWS AUTHORS"

RDEPEND=">=dev-cpp/gtkmm-3.2.0:3.0
		dev-libs/libunique:3
		>=media-libs/libmpdclient-2.3
		>=net-libs/libsoup-2.36"
DEPEND="${RDEPEND}
		virtual/pkgconfig"

src_install() {
	default
	rm -r "${ED}"/usr/doc/ || die
	make_desktop_entry guimup Guimup
}
