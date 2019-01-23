# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="af an ar az be be@latin bg bs ca ckb co cs da de el en_GB es et eu fa fi fr ga gl he hr hu hy id is it ja ka kab kk ko lt lv ms nb nl oc pa pl pt_BR pt_PT ro ru sk sl sq sr sv tg th tr uk uz vi zh_CN zh_TW"
WX_GTK_VER=3.0-gtk3

inherit gnome2-utils l10n wxwidgets xdg

DESCRIPTION="GUI gettext translations editor"
HOMEPAGE="https://poedit.net"
SRC_URI="https://github.com/vslavik/${PN}/releases/download/v${PV}-oss/${P}.tar.gz"

KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
LICENSE="MIT"
SLOT="0"

RDEPEND="
	app-text/gtkspell:3
	x11-libs/gtk+:3
	>=dev-cpp/lucene++-3.0.5
	>=dev-libs/pugixml-1.9
	dev-libs/boost:=[nls]
	dev-libs/icu:=
	>=x11-libs/wxGTK-3.0.3:${WX_GTK_VER}[X]
"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	my_rm_loc() {
		sed -i -e "/^POEDIT_LINGUAS = /s: ${1}::" locales/Makefile.in || die
		rm "locales/${1}.mo" || die
	}

	l10n_find_plocales_changes 'locales' '' '.mo'
	l10n_for_each_disabled_locale_do my_rm_loc

	setup-wxwidgets
	xdg_src_prepare
}

src_configure() {
	# CLD2 and C++ Rest are not available in Gentoo
	local myeconfargs=(
		--without-cld2
		--without-cpprest
	)

	econf "${myeconfargs[@]}"
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_icon_cache_update
}
