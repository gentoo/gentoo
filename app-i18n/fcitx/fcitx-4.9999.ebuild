# Copyright 2003-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
LUA_COMPAT=( lua5-{1..4} )

inherit cmake gnome2-utils lua-single xdg-utils

if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/fcitx/fcitx"
fi

DESCRIPTION="Fcitx (Flexible Context-aware Input Tool with eXtension) input method framework"
HOMEPAGE="https://fcitx-im.org/ https://github.com/fcitx/fcitx"
if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	SRC_URI="https://download.fcitx-im.org/data/pinyin.tar.gz -> fcitx-data-pinyin.tar.gz
		https://download.fcitx-im.org/data/table.tar.gz -> fcitx-data-table.tar.gz
		https://download.fcitx-im.org/data/py_stroke-20121124.tar.gz -> fcitx-data-py_stroke-20121124.tar.gz
		https://download.fcitx-im.org/data/py_table-20121124.tar.gz -> fcitx-data-py_table-20121124.tar.gz
		https://download.fcitx-im.org/data/en_dict-20121020.tar.gz -> fcitx-data-en_dict-20121020.tar.gz"
else
	SRC_URI="https://download.fcitx-im.org/${PN}/${P}_dict.tar.xz"
fi

# LICENSE="BSD-1 GPL-2+ LGPL-2+ MIT qt4? ( BSD )"
LICENSE="BSD-1 GPL-2+ LGPL-2+ MIT"
SLOT="4"
KEYWORDS=""
IUSE="+X +autostart +cairo debug +enchant gtk2 +gtk3 +introspection lua nls opencc +pango +table test +xkb"
REQUIRED_USE="cairo? ( X )
	lua? ( ${LUA_REQUIRED_USE} )
	pango? ( cairo )"
RESTRICT="!test? ( test )"

BDEPEND="dev-util/glib-utils
	kde-frameworks/extra-cmake-modules:0
	virtual/pkgconfig
	introspection? ( dev-libs/gobject-introspection )
	nls? ( sys-devel/gettext )"
DEPEND="dev-libs/glib:2
	sys-apps/dbus
	sys-apps/util-linux
	virtual/libiconv
	virtual/libintl
	x11-libs/libxkbcommon
	X? (
		x11-libs/libX11
		x11-libs/libXfixes
		x11-libs/libXinerama
		x11-libs/libXrender
		xkb? (
			dev-libs/libxml2
			x11-libs/libxkbfile
			x11-misc/xkeyboard-config
		)
	)
	cairo? (
		x11-libs/cairo[X]
		x11-libs/libXext
		pango? ( x11-libs/pango )
		!pango? ( media-libs/fontconfig )
	)
	enchant? ( app-text/enchant:= )
	gtk2? ( x11-libs/gtk+:2 )
	gtk3? ( x11-libs/gtk+:3 )
	lua? ( ${LUA_DEPS} )
	nls? ( sys-devel/gettext )
	opencc? ( app-i18n/opencc:0= )
	xkb? (
		app-text/iso-codes
		dev-libs/json-c:0=
	)"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-4.2.9.8-xkb.patch"
)

DOCS=(AUTHORS ChangeLog THANKS)

pkg_setup() {
	if use lua; then
		lua-single_pkg_setup
	fi
}

src_prepare() {
	if [[ "${PV}" =~ (^|\.)9999$ ]]; then
		ln -s "${DISTDIR}/fcitx-data-pinyin.tar.gz" src/im/pinyin/data/pinyin.tar.gz || die
		ln -s "${DISTDIR}/fcitx-data-table.tar.gz" src/im/table/data/table.tar.gz || die
		ln -s "${DISTDIR}/fcitx-data-py_stroke-20121124.tar.gz" src/module/pinyin-enhance/data/py_stroke-20121124.tar.gz || die
		ln -s "${DISTDIR}/fcitx-data-py_table-20121124.tar.gz" src/module/pinyin-enhance/data/py_table-20121124.tar.gz || die
		ln -s "${DISTDIR}/fcitx-data-en_dict-20121020.tar.gz" src/module/spell/dict/en_dict-20121020.tar.gz || die
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DLIB_INSTALL_DIR="${EPREFIX}/usr/$(get_libdir)"
		-DSYSCONFDIR="${EPREFIX}/etc"
		-DENABLE_CAIRO=$(usex cairo ON OFF)
		-DENABLE_DEBUG=$(usex debug ON OFF)
		-DENABLE_ENCHANT=$(usex enchant ON OFF)
		-DENABLE_GETTEXT=$(usex nls ON OFF)
		-DENABLE_GIR=$(usex introspection ON OFF)
		-DENABLE_GTK2_IM_MODULE=$(usex gtk2 ON OFF)
		-DENABLE_GTK3_IM_MODULE=$(usex gtk3 ON OFF)
		-DENABLE_LUA=$(usex lua ON OFF)
		-DENABLE_OPENCC=$(usex opencc ON OFF)
		-DENABLE_PANGO=$(usex pango ON OFF)
		-DENABLE_QT=OFF
		-DENABLE_QT_GUI=OFF
		-DENABLE_QT_IM_MODULE=OFF
		-DENABLE_SNOOPER=$(if use gtk2 || use gtk3; then echo ON; else echo OFF; fi)
		-DENABLE_TABLE=$(usex table ON OFF)
		-DENABLE_TEST=$(usex test ON OFF)
		-DENABLE_X11=$(usex X ON OFF)
		-DENABLE_XDGAUTOSTART=$(usex autostart ON OFF)
		-DENABLE_XKB=$(usex xkb ON OFF)
	)
	if use lua; then
		mycmakeargs+=(
			-DLUA_MODULE_NAME=lua
		)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install
	rm -r "${ED}/usr/share/doc/${PN}"
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	use gtk2 && gnome2_query_immodules_gtk2
	use gtk3 && gnome2_query_immodules_gtk3

	elog
	elog "Quick Phrase Editor is provided by:"
	elog "  app-i18n/fcitx-qt5:4"
	elog
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	use gtk2 && gnome2_query_immodules_gtk2
	use gtk3 && gnome2_query_immodules_gtk3
}
