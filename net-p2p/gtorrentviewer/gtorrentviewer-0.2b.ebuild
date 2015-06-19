# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/gtorrentviewer/gtorrentviewer-0.2b.ebuild,v 1.10 2014/11/22 16:54:38 pacho Exp $

EAPI=5
GCONF_DEBUG="yes"

inherit autotools eutils gnome2

MY_PN=${PN/gtorrentviewer/GTorrentViewer}
MY_P=${MY_PN}-${PV}

DESCRIPTION="A GTK2-based viewer and editor for BitTorrent meta files"
HOMEPAGE="http://gtorrentviewer.sourceforge.net/"
SRC_URI="mirror://sourceforge/gtorrentviewer/${MY_P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc x86 ~x86-fbsd"

SLOT="0"
IUSE=""

S=${WORKDIR}/${MY_P}

RDEPEND="
	net-misc/curl
	>=x11-libs/gtk+-2.4:2
	>=dev-libs/glib-2.4:2
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	mv configure.in configure.ac || die #426262

	epatch "${FILESDIR}"/${P}-curl-headers.patch
	epatch "${FILESDIR}"/${P}-underlinking.patch
	epatch "${FILESDIR}"/${P}-desktop.patch

	# Fix tests
	echo "data/gtorrentviewer.desktop.in" >> po/POTFILES.in || die

	eautoreconf
	gnome2_src_prepare
}
