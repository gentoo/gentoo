# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="An application that queries the user for a selection for printing"
HOMEPAGE="https://github.com/naelstrof/slop"
SRC_URI="https://github.com/naelstrof/slop/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="opengl"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	opengl? (
		media-libs/glew:0=
		media-libs/imlib2
		virtual/opengl
		x11-libs/libXrandr
		x11-libs/libXrender
	)"
DEPEND="
	${RDEPEND}
	opengl? (
		media-libs/glm
	)"

PATCHES=(
	"${FILESDIR}/${PN}-4.3.21-no-cppcheck.patch"
	"${FILESDIR}/${PN}-4.3.21-no-gengetopt.patch"
	"${FILESDIR}/${PN}-4.3.21-no-librt.patch"
)

src_prepare() {
	use opengl || PATCHES+=( "${FILESDIR}/${PN}-4.3.21-no-opengl.patch"  )
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_OPENGL_SUPPORT=$(usex opengl)
	)
	cmake-utils_src_configure
}
