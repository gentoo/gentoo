# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gimmage/gimmage-0.2.3.ebuild,v 1.12 2013/02/19 18:45:27 dirtyepic Exp $

EAPI=2
inherit autotools eutils

DESCRIPTION="A slim GTK-based image browser"
HOMEPAGE="http://gimmage.berlios.de/"
SRC_URI="mirror://berlios/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="debug"

RDEPEND="dev-cpp/cairomm
	>=dev-cpp/gtkmm-2.6.2:2.4
	net-misc/curl
	sys-apps/file"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc43.patch \
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

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
}
