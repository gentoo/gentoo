# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

inherit eutils gnome2

DESCRIPTION="A gtkmm front end to the GNU Debugger (gdb)"
HOMEPAGE="https://wiki.gnome.org/Apps/Nemiver"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug memoryview"

RDEPEND="
	>=dev-libs/glib-2.16:2[dbus]
	>=dev-cpp/glibmm-2.30:2
	>=dev-cpp/gtkmm-3:3.0
	>=dev-cpp/gtksourceviewmm-3:3.0
	>=gnome-base/gsettings-desktop-schemas-0.0.1
	>=gnome-base/libgtop-2.19
	x11-libs/vte:2.91
	>=dev-db/sqlite-3:3
	sys-devel/gdb
	dev-libs/boost
	memoryview? ( >=app-editors/ghex-2.90:2 )
"
# FIXME: dynamiclayout needs unreleased stable gdlmm:3
# dynamiclayout? ( >=dev-cpp/gdlmm-3.0:3 )
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	>=dev-util/intltool-0.40
	dev-util/itstool
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

PATCHES=(
	# Use RefPtr::bool() operator in the conditions, fixed in next
	# version
	"${FILESDIR}/${P}-bool-build.patch"

	# Fix compiliation warnings & errors, fixed in next version
	"${FILESDIR}/${P}-fix-build.patch"

	# Fix building with GCC-6 and CXXFLAGS="-Werror=terminate"
	"${FILESDIR}/${P}-gcc6-throw-in-dtors.patch"
)

src_configure() {
	gnome2_src_configure \
		--disable-dynamiclayout \
		--disable-static \
		--disable-symsvis \
		--enable-gsettings \
		$(use_enable debug) \
		$(use_enable memoryview)
}
