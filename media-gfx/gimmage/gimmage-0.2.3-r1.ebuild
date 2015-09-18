# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

DESCRIPTION="A slim GTK-based image browser"
HOMEPAGE="https://sourceforge.net/projects/gimmage.berlios/"
SRC_URI="mirror://sourceforge/project/${PN}.berlios/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug"

RDEPEND="
	dev-cpp/cairomm
	>=dev-cpp/gtkmm-2.6.2:2.4
	net-misc/curl
	sys-apps/file"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-as-needed.patch \
		"${FILESDIR}"/${P}-desktop-entry.patch \
		"${FILESDIR}"/${P}-gcc47.patch
	eautoreconf
}

src_configure() {
	local myconf
	use debug && myconf="--enable-debug"

	econf ${myconf}
}
