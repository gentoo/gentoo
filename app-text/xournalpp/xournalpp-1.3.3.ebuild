# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_DEPEND="
	app-text/doxygen
	media-gfx/graphviz
"
LUA_COMPAT=( lua5-3 lua5-4 )
inherit cmake docs lua-single xdg

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/xournalpp/xournalpp.git"
else
	SRC_URI="https://github.com/xournalpp/xournalpp/archive/refs/tags/v${PV}.tar.gz -> ${P}.tgz"
	KEYWORDS="~amd64 ~ppc64"
fi

DESCRIPTION="Handwriting notetaking software with PDF annotation support"
HOMEPAGE="https://github.com/xournalpp/xournalpp"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+X +lua +man +sourceview test"
REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

RDEPEND="
	app-text/poppler[cairo]
	>=dev-libs/glib-2.32.0
	dev-libs/libxml2:=
	>=dev-libs/libzip-1.0.1:=
	>=gnome-base/librsvg-2.40
	>=media-libs/portaudio-12[cxx]
	>=media-libs/libsndfile-1.0.25
	virtual/zlib:=
	>=x11-libs/gtk+-3.18.9:3[X?]
	lua? ( ${LUA_DEPS} )
	sourceview? ( >=x11-libs/gtksourceview-4.0 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	sys-apps/lsb-release
	man? ( sys-apps/help2man )
	test? ( dev-cpp/gtest )
"

PATCHES=(
	"${FILESDIR}/${PN}-1.2.8-lua.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_X11=$(usex !X)
		-DENABLE_CPPTRACE=OFF # could be USE=debug but cpptrace is unstable
		-DENABLE_GTEST=$(usex test)
		-DENABLE_GTK_SOURCEVIEW=$(usex sourceview)
		-DENABLE_PLUGINS=$(usex lua)
		-DWITH_MAN=$(usex man)
		-DMAN_COMPRESS=OFF
	)

	use lua && mycmakeargs+=( -DLUA_VERSION=$(lua_get_version) )

	cmake_src_configure
}

src_compile() {
	docs_compile
	cmake_src_compile
}

src_test() {
	# https://github.com/xournalpp/xournalpp/tree/master/test#problems-running-make-test
	eninja -C "${BUILD_DIR}" test-units
	cmake_src_test
}
