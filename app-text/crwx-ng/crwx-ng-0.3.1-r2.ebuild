# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
WX_GTK_VER="3.2-gtk3"
inherit cmake wxwidgets xdg

DESCRIPTION="Cross-platform e-book reader"
HOMEPAGE="https://gitlab.com/coolreader-ng/crwx-ng"
SRC_URI="https://gitlab.com/coolreader-ng/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+gif +svg +chm +harfbuzz +libunibreak +fribidi +zstd +libutf8proc"

CDEPEND=">=app-text/crengine-ng-0.9.7:0=[png,jpeg,fontconfig,gif=,svg=,chm=,harfbuzz=,fribidi=,zstd=,libutf8proc=]
	x11-libs/wxGTK:${WX_GTK_VER}[X]"
DEPEND="${CDEPEND}"
RDEPEND="${CDEPEND}
	virtual/ttf-fonts"

src_configure() {
	setup-wxwidgets
	cmake_src_configure
}
