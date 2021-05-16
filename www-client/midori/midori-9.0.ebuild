# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VALA_MIN_API_VERSION=0.36

inherit cmake-utils vala xdg-utils

MY_P=${PN}-v${PV}
DESCRIPTION="A lightweight web browser based on WebKitGTK+"
HOMEPAGE="https://www.midori-browser.org/"
SRC_URI="https://github.com/midori-browser/core/releases/download/v${PV}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~arm ~mips x86"
IUSE=""

RDEPEND="
	app-arch/libarchive:=
	>=app-crypt/gcr-3:=[gtk,vala]
	>=dev-db/sqlite-3.6.19:3
	>=dev-libs/glib-2.46.2:2
	>=dev-libs/json-glib-0.12
	dev-libs/libpeas[gtk]
	dev-libs/libxml2
	>=net-libs/libsoup-2.38:2.4[vala]
	>=net-libs/webkit-gtk-2.16.6:4[introspection]
	>=x11-libs/libnotify-0.7
	>=x11-libs/gtk+-3.12.0:3
"
DEPEND="${RDEPEND}
	$(vala_depend)
	dev-util/intltool
	sys-devel/gettext
"

S=${WORKDIR}/${MY_P}

src_prepare() {
	cmake-utils_src_prepare
	vala_src_prepare
	sed -i -e '/^install/s:COPYING::' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR=/usr/share/doc/${PF}
		-DVALA_EXECUTABLE="${VALAC}"
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
