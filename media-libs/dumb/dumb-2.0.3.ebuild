# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CMAKE_ECLASS=cmake
inherit cmake-multilib

DESCRIPTION="IT/XM/S3M/MOD player library with click removal and IT filters"
HOMEPAGE="https://github.com/kode54/dumb"
SRC_URI="https://github.com/kode54/dumb/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="DUMB-0.9.3"
SLOT="0/2.0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="allegro cpu_flags_x86_sse debug"

# examples requires dev-libs/argtable which not yet available on all supported
# platfroms
# examples? ( dev-libs/argtable media-libs/libsdl2 )
RDEPEND="
	allegro? (
		media-libs/allegro:0[${MULTILIB_USEDEP}]
		!media-libs/aldumb
	)"
DEPEND="${RDEPEND}"

DOCS=(
	DUMBFILE_SYSTEM.md
	README.md
	UPDATING_YOUR_PROJECTS.md
)

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_ALLEGRO4=$(usex allegro)
		-DUSE_SSE=$(usex cpu_flags_x86_sse)
		-DBUILD_EXAMPLES=OFF
	)
	# Disabled until dev-libs/argtable get keywords
	#if multilib_is_native_abi ; then
	#	mycmakeargs+=( -DBUILD_EXAMPLES=$(usex examples) )
	#else
	#	mycmakeargs+=( -DBUILD_EXAMPLES=OFF )
	#fi
	cmake-utils_src_configure
}
