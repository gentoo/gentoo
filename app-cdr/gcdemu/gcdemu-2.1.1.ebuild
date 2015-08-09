# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

CMAKE_MIN_VERSION="2.8.5"
PYTHON_COMPAT=( python2_7 )
PLOCALES="de fr no pl sl zh_CN"

# cmake-utils after gnome2, to make sure cmake-utils is used for building
inherit gnome2 cmake-utils l10n python-single-r1

DESCRIPTION="Gtk+ GUI for controlling cdemu-daemon"
HOMEPAGE="http://cdemu.org/"
SRC_URI="mirror://sourceforge/cdemu/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	app-cdr/cdemu-daemon:0/6
	>=dev-libs/glib-2.28:2
	dev-libs/gobject-introspection
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	gnome-base/librsvg:2
	sys-apps/dbus
	x11-libs/gdk-pixbuf[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/libnotify[introspection]"
DEPEND="${COMMON_DEPEND}
	dev-util/desktop-file-utils
	>=dev-util/intltool-0.21
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	python_fix_shebang src/gcdemu
	# build system doesn't respect LINGUAS :/
	l10n_find_plocales_changes po "" ".po"
	rm_po() {
		rm po/$1.po || die
	}
	l10n_for_each_disabled_locale_do rm_po
}

src_configure() {
	DOCS="AUTHORS README"
	local mycmakeargs=( -DPOST_INSTALL_HOOKS=OFF )
	cmake-utils_src_configure
}
