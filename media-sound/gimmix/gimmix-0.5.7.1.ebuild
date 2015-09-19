# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils

DESCRIPTION="a graphical music player daemon (MPD) client using GTK+2"
HOMEPAGE="https://launchpad.net/gimmix"
SRC_URI="mirror://gentoo/${PN}/${P}.tar.bz2"

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
	epatch "${FILESDIR}"/${P}-curl-headers.patch \
		"${FILESDIR}"/${P}-symbol-collision.patch
}

src_configure() {
	econf \
		$(use_enable cover) \
		$(use_enable lyrics) \
		$(use_enable taglib tageditor)
}
