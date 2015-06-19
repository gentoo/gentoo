# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/wxsvg/wxsvg-1.4.2.ebuild,v 1.2 2014/07/29 16:38:43 ssuominen Exp $

EAPI=5
WX_GTK_VER=2.8
inherit eutils wxwidgets

DESCRIPTION="C++ library to create, manipulate and render SVG files"
HOMEPAGE="http://wxsvg.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="wxWinLL-3"
SLOT="0/2" # based on SONAME of libwxsvg.so
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND=">=dev-libs/expat-2:=
	>=dev-libs/glib-2.28:2=
	dev-libs/libxml2:=
	media-libs/fontconfig:=
	media-libs/freetype:2=
	x11-libs/cairo:=
	x11-libs/pango:=
	x11-libs/wxGTK:2.8=[X]
	virtual/ffmpeg"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog TODO )

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--with-wx-config=${WX_CONFIG}
}

src_install() {
	default
	prune_libtool_files
}
