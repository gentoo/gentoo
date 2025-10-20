# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Application that queries the user for a selection for printing"
HOMEPAGE="https://github.com/naelstrof/slop"
SRC_URI="https://github.com/naelstrof/slop/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="icu opengl"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	icu? ( dev-libs/icu:= )
	opengl? (
		media-libs/glew:0=
		media-libs/libglvnd[X]
		x11-libs/libXrender
	)
"
DEPEND="
	${RDEPEND}
	media-libs/glm
	x11-base/xorg-proto
"
BDEPEND="opengl? ( virtual/pkgconfig )"

PATCHES=( "${FILESDIR}"/${P}-cmake-min-ver-3.11.patch ) # bug 964438

src_configure() {
	local mycmakeargs=(
		-DSLOP_OPENGL=$(usex opengl)
		-DSLOP_UNICODE=$(usex icu)
	)
	cmake_src_configure
}
