# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-3 )

inherit desktop flag-o-matic lua-single toolchain-funcs xdg cmake

MY_PN="s25client"
DESCRIPTION="Open source remake of The Settlers II: Gold Edition (needs original data files)"
HOMEPAGE="https://www.siedler25.org/"
SRC_URI="https://github.com/Return-To-The-Roots/${MY_PN}/releases/download/v${PV}/${MY_PN}_src_v${PV}.tar.gz"
LICENSE="GPL-2+ GPL-3 Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="${LUA_DEPS}
	app-arch/bzip2
	>=dev-libs/boost-1.73:0=[nls]
	>=media-libs/libsamplerate-0.1.9
	>=media-libs/libsdl2-2.0.10-r2[opengl,sound,video]
	media-libs/libsndfile
	media-libs/sdl2-mixer[vorbis,wav]
	net-libs/miniupnpc
	virtual/opengl
"

DEPEND="
	${RDEPEND}
	test? ( >=sys-devel/clang-5 )
"

BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.0_pre20200723-cmake_lua_version.patch
)

S="${WORKDIR}/${MY_PN}_v${PV}"

# Build type is checked but blank is valid.
CMAKE_BUILD_TYPE=

src_prepare() {
	cmake_src_prepare
	rm -v external/{kaguya,libutil}/cmake/FindLua.cmake || die
}

src_configure() {
	if [[ -f revision.txt ]]; then
		local RTTR_REVISION="$(< revision.txt)"
	elif [[ -n ${COMMIT} ]]; then
		local RTTR_REVISION="${COMMIT}"
	else
		die "Could not determine RTTR_REVISION."
	fi

	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DCCACHE_PROGRAM=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_ClangFormat=ON
		-DCMAKE_SKIP_RPATH=ON
		-DLUA_VERSION=$(lua_get_version)
		-DRTTR_BUILD_UPDATER=OFF
		-DRTTR_ENABLE_OPTIMIZATIONS=OFF
		-DRTTR_ENABLE_SANITIZERS=$(usex test)
		-DRTTR_ENABLE_WERROR=OFF
		-DRTTR_INCLUDE_DEVTOOLS=OFF
		-DRTTR_LIBDIR="$(get_libdir)"
		-DRTTR_REVISION="${RTTR_REVISION}"
		-DRTTR_USE_SYSTEM_LIBS=ON
		-DRTTR_VERSION="${PV##*_pre}" # Tests expect a date for snapshots.
	)

	if use test && tc-is-gcc; then
		# Work around libasan and libsandbox both wanting to be first.
		append-ldflags -static-libasan
	fi

	cmake_src_configure
}

src_test() {
	SDL_AUDIODRIVER=dummy \
	SDL_VIDEODRIVER=dummy \
	USER=$(whoami) \
	cmake_src_test
}

src_install() {
	cmake_src_install

	doicon -s 64 tools/release/debian/s25rttr.png
	make_desktop_entry "${MY_PN}" "Return to the Roots"
}

pkg_postinst() {
	xdg_pkg_postinst

	if ! has_version -r games-strategy/settlers-2-gold-data; then
		elog "Install games-strategy/settlers-2-gold-data or manually copy the DATA"
		elog "and GFX directories from original data files into"
		elog "${EPREFIX}/usr/share/${PN}/S2."
	fi
}
