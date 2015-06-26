# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/gimmix/gimmix-0.5.7.2.ebuild,v 1.4 2015/06/26 08:50:16 ago Exp $

EAPI=4
inherit autotools eutils

DESCRIPTION="a graphical music player daemon (MPD) client using GTK+2"
HOMEPAGE="https://code.google.com/p/gimmix/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="cover lyrics taglib"

RDEPEND=">=media-libs/libmpd-0.17
	gnome-base/libglade
	x11-libs/gtk+:2
	cover? ( net-libs/libnxml net-misc/curl )
	lyrics? ( net-libs/libnxml net-misc/curl )
	taglib? ( >=media-libs/taglib-1.5 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/intltool"

DOCS=( AUTHORS ChangeLog README TODO )

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.5.7.1-curl-headers.patch
	sed -i -e "/^Icon/s/\.png$//" \
		-e "/^Categories/s/Application;//" data/gimmix.desktop

	# broken build system in tarball
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable cover) \
		$(use_enable lyrics) \
		$(use_enable taglib tageditor)
}
