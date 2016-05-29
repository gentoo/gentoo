# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG="no"

inherit cmake-utils eutils gnome2 vala

DESCRIPTION="Simple backup tool using duplicity back-end"
HOMEPAGE="https://launchpad.net/deja-dup/"
SRC_URI="https://launchpad.net/${PN}/34/${PV}/+download/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nautilus test"
RESTRICT="test"

COMMON_DEPEND="
	app-admin/packagekit-base
	app-crypt/libsecret[vala]
	>=dev-libs/glib-2.34:2[dbus]
	>=dev-libs/libpeas-1.0
	>=x11-libs/gtk+-3.10:3
	>=x11-libs/libnotify-0.7

	>=app-backup/duplicity-0.6.23
	dev-libs/dbus-glib

	nautilus? ( gnome-base/nautilus )
"
RDEPEND="${COMMON_DEPEND}
	gnome-base/dconf
	gnome-base/gvfs[fuse]
"
DEPEND="${COMMON_DEPEND}
	$(vala_depend)
	app-text/yelp-tools
	dev-perl/Locale-gettext
	virtual/pkgconfig
	dev-util/intltool
	sys-devel/gettext
"

src_prepare() {
	sed \
		-e '/RPATH/s:PKG_LIBEXECDIR:PKG_LIBDIR:g' \
		-i CMakeLists.txt || die
	vala_src_prepare
	gnome2_src_prepare
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DVALA_EXECUTABLE="${VALAC}"
		-DENABLE_CCPANEL=OFF
		-DENABLE_PK=OFF
		-DENABLE_UNITY=OFF
		-DENABLE_UNITY_CCPANEL=OFF
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}"/etc
		$(cmake-utils_use_enable nautilus)
		$(cmake-utils_use_enable test TESTING)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
}
