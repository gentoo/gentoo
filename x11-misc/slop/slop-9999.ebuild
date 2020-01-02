# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Application that queries the user for a selection for printing"
HOMEPAGE="https://github.com/naelstrof/slop"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/naelstrof/slop.git"
else
	SRC_URI="https://github.com/naelstrof/slop/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0/${PV}"
IUSE="opengl"

RDEPEND="
	dev-libs/icu:=
	x11-libs/libX11
	x11-libs/libXext
	opengl? (
		media-libs/glew:0=
		virtual/opengl
		x11-libs/libXrender:=
	)"
DEPEND="${RDEPEND}
	media-libs/glm
"

src_configure() {
	local mycmakeargs=(
		-DSLOP_OPENGL=$(usex opengl)
	)
	cmake_src_configure
}
