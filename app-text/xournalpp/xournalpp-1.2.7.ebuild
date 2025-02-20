# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_DEPEND="
	app-text/doxygen
	media-gfx/graphviz
"

LUA_COMPAT=( lua5-{3..4} )

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

IUSE="+X +plugins test"
RESTRICT="!test? ( test )"
REQUIRED_USE="plugins? ( ${LUA_REQUIRED_USE} )"

RDEPEND="
	app-text/poppler[cairo]
	>=dev-libs/glib-2.32.0
	dev-libs/libxml2
	>=dev-libs/libzip-1.0.1:=
	>=gnome-base/librsvg-2.40
	>=gui-libs/gtksourceview-4.0.0
	>=media-libs/portaudio-12[cxx]
	>=media-libs/libsndfile-1.0.25
	sys-libs/zlib:=
	>=x11-libs/gtk+-3.18.9:3[X?]
	plugins? ( ${LUA_DEPS} )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	sys-apps/help2man
	sys-apps/lsb-release
	test? ( dev-cpp/gtest )
"

PATCHES=(
	# see https://github.com/xournalpp/xournalpp/discussions/6217
	"${FILESDIR}/${PN}-1.1.1-nostrip.patch"
	# TODO: check https://github.com/xournalpp/xournalpp/issues/6216 when bumping
	"${FILESDIR}/${PN}-1.2.3-nocompress.patch"
	"${FILESDIR}/${PN}-1.2.3-lua-5-4.patch"
)

src_configure() {
	local mycmakeargs=(
		# defaults
		-Dxournalpp_LINT=OFF
		-DENABLE_PROFILING=OFF
		# -DUSE_GTK_SOURCEVIEW=ON # to prevent automagic, could be a USE flag
		# -DONLY_CONFIGURE_FOR_TARGET_POT=OFF # for >1.2.5

		-DCMAKE_DISABLE_FIND_PACKAGE_X11="$(usex X OFF ON)"
		-DENABLE_GTEST="$(usex test)"
		-DENABLE_PLUGINS="$(usex plugins)"
	)

	use plugins && mycmakeargs+=( -DLUA_VERSION="$(lua_get_version)" )
	use test && mycmakeargs+=( -DDOWNLOAD_GTEST=NO )

	cmake_src_configure
}

src_compile() {
	docs_compile
	cmake_src_compile
}
