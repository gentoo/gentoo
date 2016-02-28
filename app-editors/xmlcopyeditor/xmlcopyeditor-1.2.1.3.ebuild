# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

WX_GTK_VER="3.0"

inherit autotools wxwidgets

DESCRIPTION="XML Copy Editor is a fast, free, validating XML editor"
HOMEPAGE="http://xml-copy-editor.sourceforge.net/"
SRC_URI="mirror://sourceforge/xml-copy-editor/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="aqua nls"

RDEPEND="
	app-text/aspell
	dev-libs/libxml2
	dev-libs/libxslt
	dev-libs/xerces-c[icu]
	dev-libs/libpcre
	!aqua? ( x11-libs/wxGTK:${WX_GTK_VER}[X] )
	aqua? ( x11-libs/wxGTK:${WX_GTK_VER}[aqua] )"
DEPEND="${RDEPEND}
	dev-libs/boost
	dev-util/intltool"

DOCS=( AUTHORS ChangeLog README NEWS )

src_prepare() {
	# bug #440744
	sed -i  -e 's/ -Wall -g -fexceptions//g' configure.ac || die
	eautoreconf

	need-wxwidgets unicode
}

src_configure() {
	econf $(use_enable nls)
}
