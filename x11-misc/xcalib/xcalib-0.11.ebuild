# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Tiny monitor calibration loader for X.org"
HOMEPAGE="https://codeberg.org/OpenICC/xcalib"
SRC_URI="https://codeberg.org/OpenICC/xcalib/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXrandr
	x11-libs/libXxf86vm
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	x11-libs/libXext
"

PATCHES=( "$FILESDIR"/${P}-cmake4.patch )

src_configure() {
	local mycmakeargs=(
		# not packaged yet
		-DCMAKE_DISABLE_FIND_PACKAGE_Oyjl=ON
	)
	cmake_src_configure
}
