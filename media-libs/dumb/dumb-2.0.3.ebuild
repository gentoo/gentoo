# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib

DESCRIPTION="Module/tracker based music format parser and player library"
HOMEPAGE="https://github.com/kode54/dumb"
SRC_URI="https://github.com/kode54/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="DUMB-0.9.3"
SLOT="0/2"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="allegro cpu_flags_x86_sse examples"

RDEPEND="
	allegro? (
		media-libs/allegro:0[${MULTILIB_USEDEP}]
		!media-libs/aldumb
	)
	examples? (
		>=dev-libs/argtable-2
		media-libs/libsdl2[sound]
	)
"

DEPEND="
	${RDEPEND}
"

PATCHES=(
	"${FILESDIR}"/${P}-pkg-config.patch
)

DOCS=(
	CHANGELOG.md
	DUMBFILE_SYSTEM.md
	README.md
	UPDATING_YOUR_PROJECTS.md
)

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_ALLEGRO4=$(usex allegro)
		-DBUILD_EXAMPLES=$(multilib_native_usex examples)
		-DUSE_SSE=$(usex cpu_flags_x86_sse)
	)
	cmake_src_configure
}
