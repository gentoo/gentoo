# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0-gtk3"
inherit autotools wxwidgets xdg

DESCRIPTION="XML Copy Editor is a fast, free, validating XML editor"
HOMEPAGE="http://xml-copy-editor.sourceforge.net/"
SRC_URI="mirror://sourceforge/xml-copy-editor/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 -ppc ~x86 ~amd64-linux ~x86-linux"  # -ppc due SSE2 requirement
IUSE="aqua nls"

RDEPEND="
	app-text/aspell
	dev-libs/libxml2
	dev-libs/libxslt
	dev-libs/xerces-c[cpu_flags_x86_sse2,icu]
	dev-libs/libpcre
	x11-libs/wxGTK:${WX_GTK_VER}[X]"
DEPEND="${RDEPEND}
	dev-libs/boost"
BDEPEND="dev-util/intltool
	virtual/pkgconfig"

S="${WORKDIR}"/${PN}

PATCHES=( "${FILESDIR}"/${P}-no-automagic-enchant.patch )

src_prepare() {
	default

	# bug #440744
	sed -i  -e 's/ -Wall -g -fexceptions//g' configure.ac || die
	eautoreconf
}

src_configure() {
	setup-wxwidgets unicode
	econf \
		--with-gtk=3.0 \
		--with-wx-config="${WX_CONFIG}" \
		$(use_enable nls)
}
