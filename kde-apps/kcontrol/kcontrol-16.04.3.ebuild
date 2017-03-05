# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
KMNAME="kde-runtime"
inherit kde4-meta

DESCRIPTION="The KDE Control Center"
KEYWORDS="amd64 ~arm x86"
IUSE="debug"

RDEPEND="
	$(add_kdeapps_dep zeroconf-ioslave)
	|| ( kde-plasma/khotkeys:4 kde-plasma/khotkeys:5 )
"

src_prepare() {
	kde4-meta_src_prepare
	if use handbook; then
		sed -i -e "/add_subdirectory(kcm_ssl)/d" doc/kcontrol/CMakeLists.txt || die
		sed -i -e "/add_subdirectory(trash)/d" doc/kcontrol/CMakeLists.txt || die
	fi
}
