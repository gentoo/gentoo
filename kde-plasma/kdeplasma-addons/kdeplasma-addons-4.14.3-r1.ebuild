# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WEBKIT_REQUIRED="always"
inherit flag-o-matic kde4-base

DESCRIPTION="Extra Plasma applets and engines"
LICENSE="GPL-2 LGPL-2"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="attica debug desktopglobe exif fcitx ibus json oauth +pim
qalculate qwt scim"

RESTRICT=test
# tests hang

# krunner is only needed to generate dbus interface for lancelot
DEPEND="
	app-crypt/qca:2[qt4(+)]
	kde-plasma/krunner:4
	kde-plasma/plasma-workspace:4
	x11-misc/shared-mime-info
	attica? ( dev-libs/libattica )
	desktopglobe? ( $(add_kdeapps_dep marble) )
	exif? ( $(add_kdeapps_dep libkexiv2) )
	fcitx? ( app-i18n/fcitx[dbus(+)] )
	ibus? ( app-i18n/ibus )
	json? ( dev-libs/qjson )
	oauth? ( dev-libs/qoauth:0 )
	pim? ( $(add_kdeapps_dep kdepimlibs) )
	qalculate? ( sci-libs/libqalculate )
	qwt? ( x11-libs/qwt:5 )
	scim? ( app-i18n/scim )
"
RDEPEND="${DEPEND}
	app-crypt/qca:2[ssl]
"

src_configure() {
	local mycmakeargs=(
		-DDBUS_INTERFACES_INSTALL_DIR="${EPREFIX}/usr/share/dbus-1/interfaces/"
		-DWITH_Nepomuk=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_Eigen2=ON
		$(cmake-utils_use_with attica LibAttica)
		$(cmake-utils_use_with desktopglobe Marble)
		$(cmake-utils_use_with exif Kexiv2)
		$(cmake-utils_use_build ibus)
		$(cmake-utils_use_with json QJSON)
		$(cmake-utils_use_with oauth QtOAuth)
		$(cmake-utils_use_with pim KdepimLibs)
		$(cmake-utils_use_with qalculate)
		$(cmake-utils_use_with qwt)
		$(cmake-utils_use_build scim)
	)

	kde4-base_src_configure
}
