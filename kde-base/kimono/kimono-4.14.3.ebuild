# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kimono/kimono-4.14.3.ebuild,v 1.4 2015/02/16 08:31:55 ago Exp $

EAPI=5

inherit mono-env kde4-base

DESCRIPTION="C# bindings for KDE"
KEYWORDS="amd64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="akonadi debug nepomuk plasma"

DEPEND="
	dev-lang/mono
	$(add_kdebase_dep qyoto 'webkit')
	$(add_kdebase_dep smokeqt)
	$(add_kdebase_dep smokekde 'nepomuk?')
	plasma? ( $(add_kdebase_dep smokeqt 'webkit') )
"
RDEPEND="${DEPEND}"

pkg_setup() {
	mono-env_pkg_setup
	kde4-base_pkg_setup
}

src_prepare() {
	kde4-base_src_prepare

	sed -i "/add_subdirectory( examples )/ s:^:#:" plasma/CMakeLists.txt
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with akonadi)
		$(cmake-utils_use_with akonadi KdepimLibs)
		$(cmake-utils_use_with nepomuk)
		$(cmake-utils_use_disable plasma)
		-DWITH_Soprano=OFF
	)
	kde4-base_src_configure
}
