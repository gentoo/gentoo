# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python3_{4,5,6,7} )

inherit cmake-utils gnome2-utils python-single-r1 xdg-utils

DESCRIPTION="Gtk+ GUI for controlling cdemu-daemon"
HOMEPAGE="http://cdemu.org/"
SRC_URI="mirror://sourceforge/cdemu/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# librsvg for pixbuf-loader
RDEPEND="${PYTHON_DEPS}
	app-cdr/cdemu-daemon:0/7
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	gnome-base/librsvg:2
	x11-libs/gdk-pixbuf[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/libnotify[introspection]"
DEPEND="
	dev-util/desktop-file-utils
	>=dev-util/intltool-0.21
	sys-devel/gettext
	virtual/pkgconfig"

DOCS=( AUTHORS README )

src_prepare() {
	cmake-utils_src_prepare
	python_fix_shebang src/gcdemu
}

src_configure() {
	local mycmakeargs=( -DPOST_INSTALL_HOOKS=OFF )
	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_schemas_update
}
