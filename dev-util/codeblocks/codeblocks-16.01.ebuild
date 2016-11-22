# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
WX_GTK_VER="2.8"

inherit eutils wxwidgets

DESCRIPTION="The open source, cross platform, free C++ IDE"
HOMEPAGE="http://www.codeblocks.org/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~x86-fbsd"
SRC_URI="mirror://sourceforge/codeblocks/${P/-/_}.tar.gz"

IUSE="contrib debug pch static-libs"

S="${WORKDIR}/${P}.release"

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
	touch "${S}"/revision.m4 -r "${S}"/acinclude.m4

	setup-wxwidgets
	econf \
		--with-wx-config="${WX_CONFIG}" \
		$(use_enable debug) \
		$(use_enable pch) \
		$(use_enable static-libs static) \
		$(use_with contrib contrib-plugins all)
}
