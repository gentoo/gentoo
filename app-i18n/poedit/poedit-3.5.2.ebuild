# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PLOCALES="af an ar az be bg bs ca ckb co cs da de el en_GB es et eu fa fi fr ga gl he hr hu hy id is it ja ka kab kk ko lt lv ms nb nl oc pa pl pt_BR pt_PT ro ru sk sl sq sr sv tg th tr uk uz vi zh_CN zh_TW"
WX_GTK_VER=3.2-gtk3

inherit plocale wxwidgets xdg

DESCRIPTION="GUI gettext translations editor"
HOMEPAGE="https://poedit.net"
SRC_URI="https://github.com/vslavik/${PN}/releases/download/v${PV}-oss/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"

KEYWORDS="amd64 ppc ~ppc64 x86"

RDEPEND="
	app-text/gtkspell:3
	x11-libs/gtk+:3
	>=dev-cpp/lucene++-3.0.5
	>=dev-libs/pugixml-1.9
	dev-libs/boost:=[nls]
	dev-libs/icu:=
	x11-libs/wxGTK:${WX_GTK_VER}[webkit,X]
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
	my_rm_loc() {
		sed -i -e "/^POEDIT_LINGUAS = /s: ${1}::" locales/Makefile.in || die
		rm "locales/${1}.mo" || die
	}

	plocale_find_changes 'locales' '' '.mo'
	plocale_for_each_disabled_locale my_rm_loc

	default
}

src_configure() {
	setup-wxwidgets
	# CLD2 and C++ Rest are not available in Gentoo, bug 674916
	local myeconfargs=(
		--without-cld2
		--without-cpprest
	)

	econf "${myeconfargs[@]}"
}
