# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
WX_GTK_VER="3.0-gtk3"
inherit cmake wxwidgets

DESCRIPTION="Cross-platform e-book reader"
HOMEPAGE="https://gitlab.com/coolreader-ng/crwx-ng"
SRC_URI="https://gitlab.com/coolreader-ng/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+gif +svg +chm +harfbuzz +libunibreak +fribidi +zstd +libutf8proc"

CDEPEND=">=app-text/crengine-ng-0.9.3[png,jpeg,fontconfig,gif=,svg=,chm=,harfbuzz=,fribidi=,zstd=,libutf8proc=]
	x11-libs/wxGTK:${WX_GTK_VER}[X]"
BDEPEND="${CDEPEND}"
RDEPEND="${CDEPEND}
	virtual/ttf-fonts"

PATCHES=( "${FILESDIR}"/${P}.patch )
