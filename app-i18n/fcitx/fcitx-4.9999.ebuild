# Copyright 2003-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils gnome2-utils xdg-utils

if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://gitlab.com/fcitx/fcitx.git"
fi

DESCRIPTION="Fcitx (Flexible Context-aware Input Tool with eXtension) input method framework"
HOMEPAGE="https://fcitx-im.org/ https://gitlab.com/fcitx/fcitx"
if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	SRC_URI="https://download.fcitx-im.org/data/pinyin.tar.gz -> fcitx-data-pinyin.tar.gz
		https://download.fcitx-im.org/data/table.tar.gz -> fcitx-data-table.tar.gz
		https://download.fcitx-im.org/data/py_stroke-20121124.tar.gz -> fcitx-data-py_stroke-20121124.tar.gz
		https://download.fcitx-im.org/data/py_table-20121124.tar.gz -> fcitx-data-py_table-20121124.tar.gz
		https://download.fcitx-im.org/data/en_dict-20121020.tar.gz -> fcitx-data-en_dict-20121020.tar.gz"
else
	SRC_URI="https://download.fcitx-im.org/${PN}/${P}_dict.tar.xz"
fi

LICENSE="BSD-1 GPL-2+ LGPL-2+ MIT"
SLOT="4"
KEYWORDS=""
IUSE="+X +autostart +cairo debug +enchant gtk2 +gtk3 +introspection lua nls opencc +pango static-libs +table test +xml"
RESTRICT="!test? ( test )"
REQUIRED_USE="cairo? ( X ) pango? ( cairo )"

RDEPEND="dev-libs/glib:2
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
		xml? (
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
	enchant? ( app-text/enchant:0= )
	gtk2? ( x11-libs/gtk+:2 )
	gtk3? ( x11-libs/gtk+:3 )
	introspection? ( dev-libs/gobject-introspection )
	lua? ( dev-lang/lua:= )
	nls? ( sys-devel/gettext )
	opencc? ( app-i18n/opencc:= )
	xml? (
		app-text/iso-codes
		dev-libs/libxml2
	)"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	kde-frameworks/extra-cmake-modules:5
	virtual/pkgconfig"

DOCS=(AUTHORS ChangeLog THANKS)

src_prepare() {
	if [[ "${PV}" =~ (^|\.)9999$ ]]; then
		ln -s "${DISTDIR}/fcitx-data-pinyin.tar.gz" src/im/pinyin/data/pinyin.tar.gz || die
		ln -s "${DISTDIR}/fcitx-data-table.tar.gz" src/im/table/data/table.tar.gz || die
		ln -s "${DISTDIR}/fcitx-data-py_stroke-20121124.tar.gz" src/module/pinyin-enhance/data/py_stroke-20121124.tar.gz || die
		ln -s "${DISTDIR}/fcitx-data-py_table-20121124.tar.gz" src/module/pinyin-enhance/data/py_table-20121124.tar.gz || die
		ln -s "${DISTDIR}/fcitx-data-en_dict-20121020.tar.gz" src/module/spell/dict/en_dict-20121020.tar.gz || die
	fi

	# https://gitlab.com/fcitx/fcitx/issues/250
	sed \
		-e "/find_package(XkbFile REQUIRED)/i\\    if(ENABLE_X11)" \
		-e "/find_package(XkbFile REQUIRED)/s/^/    /" \
		-e "/find_package(XkbFile REQUIRED)/a\\        find_package(XKeyboardConfig REQUIRED)\n    endif(ENABLE_X11)" \
		-e "/^find_package(XKeyboardConfig REQUIRED)/,+1d" \
		-i CMakeLists.txt

	cmake-utils_src_prepare
	xdg_environment_reset
}

src_configure() {
	local mycmakeargs=(
		-DLIB_INSTALL_DIR="${EPREFIX}/usr/$(get_libdir)"
		-DSYSCONFDIR="${EPREFIX}/etc"
		-DENABLE_CAIRO=$(usex cairo)
		-DENABLE_DEBUG=$(usex debug)
		-DENABLE_ENCHANT=$(usex enchant)
		-DENABLE_GETTEXT=$(usex nls)
		-DENABLE_GIR=$(usex introspection)
		-DENABLE_GTK2_IM_MODULE=$(usex gtk2)
		-DENABLE_GTK3_IM_MODULE=$(usex gtk3)
		-DENABLE_LIBXML2=$(usex xml)
		-DENABLE_LUA=$(usex lua)
		-DENABLE_OPENCC=$(usex opencc)
		-DENABLE_PANGO=$(usex pango)
		-DENABLE_QT=OFF
		-DENABLE_QT_GUI=OFF
		-DENABLE_QT_IM_MODULE=OFF
		-DENABLE_SNOOPER=$(if use gtk2 || use gtk3; then echo yes; else echo no; fi)
		-DENABLE_STATIC=$(usex static-libs)
		-DENABLE_TABLE=$(usex table)
		-DENABLE_TEST=$(usex test)
		-DENABLE_X11=$(usex X)
		-DENABLE_XDGAUTOSTART=$(usex autostart)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	rm -r "${ED}usr/share/doc/${PN}"
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	use gtk2 && gnome2_query_immodules_gtk2
	use gtk3 && gnome2_query_immodules_gtk3

	elog
	elog "Quick Phrase Editor is provided by:"
	elog "  app-i18n/fcitx-qt5:4"
	elog
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	use gtk2 && gnome2_query_immodules_gtk2
	use gtk3 && gnome2_query_immodules_gtk3
}
