# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/deja-dup/deja-dup-34.0.ebuild,v 1.2 2015/06/26 17:36:57 jlec Exp $

EAPI=5

GNOME2_LA_PUNT="yes"

VALA_MIN_API_VERSION="0.24"
VALA_MAX_API_VERSION="0.26"

inherit cmake-utils eutils gnome2 vala

DESCRIPTION="Simple backup tool using duplicity back-end"
HOMEPAGE="https://launchpad.net/deja-dup/"
SRC_URI="http://launchpad.net/${PN}/34/${PV}/+download/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nautilus test"

RESTRICT="test"

COMMON_DEPEND="
	app-crypt/libsecret[vala]
	>=dev-libs/glib-2.34:2
	>=dev-libs/libpeas-1.0
	>=x11-libs/gtk+-3.6:3
	>=x11-libs/libnotify-0.7

	>=app-backup/duplicity-0.6.23
	dev-libs/dbus-glib

	nautilus? ( gnome-base/nautilus )"
RDEPEND="${COMMON_DEPEND}
	gnome-base/dconf
	gnome-base/gvfs[fuse]"
DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	$(vala_depend)
	dev-perl/Locale-gettext
	virtual/pkgconfig
	dev-util/intltool
	sys-devel/gettext"

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
		-DENABLE_CCPANEL=OFF
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
