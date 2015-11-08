# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
WX_GTK_VER="3.0"

inherit eutils wxwidgets

DESCRIPTION="The open source, cross platform, free C++ IDE"
HOMEPAGE="http://www.codeblocks.org/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~x86-fbsd"
SRC_URI="mirror://sourceforge/codeblocks/${P/-/_}-1.tar.gz"

IUSE="contrib debug pch static-libs"

RDEPEND="app-arch/zip
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	contrib? (
		app-text/hunspell
		dev-libs/boost:=
		dev-libs/libgamin
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	need-wxwidgets unicode
	econf \
		--with-wx-config="${WX_CONFIG}" \
		$(use_enable debug) \
		$(use_enable pch) \
		$(use_enable static-libs static) \
		$(use_with contrib contrib-plugins all)
}

src_install() {
	default
	prune_libtool_files
}
