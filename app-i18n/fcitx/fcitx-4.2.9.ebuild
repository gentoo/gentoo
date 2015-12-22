# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils eutils gnome2-utils fdo-mime multilib readme.gentoo

DESCRIPTION="Flexible Contect-aware Input Tool with eXtension support"
HOMEPAGE="http://fcitx-im.org/"
SRC_URI="http://download.fcitx-im.org/fcitx/${P}_dict.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+X +autostart +cairo +dbus debug +enchant gtk gtk3 icu introspection lua
nls opencc +pango qt4 static-libs +table test +xml"

REQUIRED_USE="cairo? ( X ) gtk? ( X ) gtk3? ( X ) qt4? ( X )"

RDEPEND="
	X? (
		x11-libs/libX11
		x11-libs/libXinerama
	)
	cairo? (
		x11-libs/cairo[X]
		pango? ( x11-libs/pango[X] )
		!pango? ( media-libs/fontconfig )
	)
	dbus? ( sys-apps/dbus )
	enchant? ( app-text/enchant )
	gtk? (
		x11-libs/gtk+:2
		dev-libs/glib:2
		dev-libs/dbus-glib
	)
	gtk3? (
		x11-libs/gtk+:3
		dev-libs/glib:2
		dev-libs/dbus-glib
	)
	icu? ( dev-libs/icu:= )
	introspection? ( dev-libs/gobject-introspection )
	lua? ( dev-lang/lua:= )
	nls? ( sys-devel/gettext )
	opencc? ( app-i18n/opencc )
	qt4? (
		dev-qt/qtdbus:4
		dev-qt/qtgui:4[glib]
	)
	xml? (
		app-text/iso-codes
		dev-libs/libxml2
		x11-libs/libxkbfile
	)"
DEPEND="${RDEPEND}
	virtual/libintl
	virtual/pkgconfig
	kde-frameworks/extra-cmake-modules
	x11-libs/libxkbcommon"

DOCS=( AUTHORS ChangeLog README THANKS TODO
	doc/pinyin.txt doc/cjkvinput.txt doc/API.txt doc/Develop_Readme )
HTML_DOCS=( doc/wb_fh.htm )

src_prepare() {
	use autostart && DOC_CONTENTS="You have enabled the autostart USE flag,
	which will let fcitx start automatically on XDG compatible desktop
	environments, such as Gnome, KDE, LXDE, LXQt and Xfce. If you use
	~/.xinitrc to configure your desktop, make sure to include the fcitx
	command to start it."
	epatch_user
}

src_configure() {
	local mycmakeargs="
		-DLIB_INSTALL_DIR=/usr/$(get_libdir)
		-DSYSCONFDIR=/etc/
		$(cmake-utils_use_enable X X11)
		$(cmake-utils_use_enable autostart XDGAUTOSTART)
		$(cmake-utils_use_enable cairo CAIRO)
		$(cmake-utils_use_enable dbus DBUS)
		$(cmake-utils_use_enable debug DEBUG)
		$(cmake-utils_use_enable enchant ENCHANT)
		$(cmake-utils_use_enable gtk GTK2_IM_MODULE)
		$(cmake-utils_use_enable gtk SNOOPER)
		$(cmake-utils_use_enable gtk3 GTK3_IM_MODULE)
		$(cmake-utils_use_enable gtk3 SNOOPER)
		$(cmake-utils_use_enable icu ICU)
		$(cmake-utils_use_enable introspection GIR)
		$(cmake-utils_use_enable lua LUA)
		$(cmake-utils_use_enable nls GETTEXT)
		$(cmake-utils_use_enable opencc OPENCC)
		$(cmake-utils_use_enable pango PANGO)
		$(cmake-utils_use_enable qt4 QT)
		$(cmake-utils_use_enable qt4 QT_IM_MODULE)
		$(cmake-utils_use_enable qt4 QT_GUI)
		$(cmake-utils_use_enable static-libs STATIC)
		$(cmake-utils_use_enable table TABLE)
		$(cmake-utils_use_enable test TEST)
		$(cmake-utils_use_enable xml LIBXML2)"
	if use gtk || use gtk3 || use qt4 ; then
		mycmakeargs+=" -DENABLE_GLIB2=ON "
	fi
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	rm -rf "${ED}"/usr/share/doc/${PN} || die
	use autostart && readme.gentoo_create_doc
}

pkg_postinst() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	use gtk && gnome2_query_immodules_gtk2
	use gtk3 && gnome2_query_immodules_gtk3
	use autostart && readme.gentoo_pkg_postinst
}

pkg_postrm() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	use gtk && gnome2_query_immodules_gtk2
	use gtk3 && gnome2_query_immodules_gtk3
}
