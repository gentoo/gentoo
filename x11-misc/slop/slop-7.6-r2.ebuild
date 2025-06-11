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
		media-libs/libglvnd
		virtual/opengl
		x11-libs/libXrender:=
	)
"
BDEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
DEPEND="
	${RDEPEND}
	media-libs/glm
"

PATCHES=(
	"${FILESDIR}/${PN}"-7.5-missing-header.patch
	"${FILESDIR}/${P}"-cmake4.patch
)

src_prepare() {
	use icu && eapply "${FILESDIR}/"icu-75.1-cxx17.patch
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DSLOP_OPENGL=$(usex opengl)
		-DSLOP_UNICODE=$(usex icu)
	)
	cmake_src_configure
}
