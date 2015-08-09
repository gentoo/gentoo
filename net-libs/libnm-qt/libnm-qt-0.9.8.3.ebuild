# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_REQUIRED="never"
inherit kde4-base

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	KEYWORDS="amd64 x86"
	SRC_URI="mirror://kde/unstable/networkmanager-qt/${PV}/src/${P}.tar.xz"
else
	KEYWORDS=""
fi

DESCRIPTION="NetworkManager bindings for Qt"
HOMEPAGE="https://projects.kde.org/projects/extragear/libs/libnm-qt"

LICENSE="LGPL-2"
SLOT="0/1"
IUSE="debug doc modemmanager test"

RDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	net-misc/mobile-broadband-provider-info
	|| (
		>=net-misc/networkmanager-0.9.8.4[consolekit]
		>=net-misc/networkmanager-0.9.8.4[systemd]
	)
	modemmanager? ( >=net-libs/libmm-qt-1.0.0 )
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=OFF
		$(cmake-utils_use_find_package doc Doxygen)
		$(cmake-utils_use !modemmanager DISABLE_MODEMMANAGERQT)
		$(cmake-utils_use !test DISABLE_TESTING)
	)

	kde4-base_src_configure
}

src_install() {
	if use doc; then
		{ cd "${BUILD_DIR}" && doxygen; } || die "Generating documentation failed"
		HTML_DOCS=( "${BUILD_DIR}/doc/html/" )
	fi

	cmake-utils_src_install
}
