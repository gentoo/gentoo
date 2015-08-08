# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

VALA_MIN_API_VERSION=0.22
CMAKE_MAKEFILE_GENERATOR=ninja

inherit cmake-utils fdo-mime gnome2 vala

DESCRIPTION="Twitter client for Linux"
HOMEPAGE="http://birdieapp.github.io/"
SRC_URI="https://github.com/birdieapp/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-db/sqlite:3
	>=dev-libs/granite-0.2.1
	dev-libs/json-glib
	dev-libs/libdbusmenu
	dev-libs/libgee:0
	net-libs/libsoup:2.4
	net-libs/rest:0.7
	media-libs/libcanberra
	net-im/pidgin
	net-libs/webkit-gtk:3
	>=x11-libs/gtk+-3.10:3
	x11-libs/gtksourceview:3.0
	x11-libs/libnotify
	x11-libs/libXtst
"
DEPEND="${RDEPEND}
	$(vala_depend)
"

src_prepare() {
	sed \
		-e '/ggdb/d' \
		-e 's:gtk-update-icon-cache:true:g' \
		-e 's:update-desktop-database:true:g' \
		-i icons/CMakeLists.txt data/CMakeLists.txt CMakeLists.txt || die
	vala_src_prepare
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DVALA_EXECUTABLE="${VALAC}"
		-DGSETTINGS_COMPILE=OFF
		)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
}

pkg_preinst() {
	gnome2_pkg_preinst
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_pkg_postinst
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_pkg_postrm
}
