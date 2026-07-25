# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-3 lua5-4 lua5-5 )
inherit cmake lua-single xdg flag-o-matic

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/xournalpp/xournalpp.git"
else
	SRC_URI="https://github.com/xournalpp/xournalpp/archive/refs/tags/v${PV}.tar.gz -> ${P}.tgz"
	KEYWORDS="~amd64 ~ppc64"
fi

DESCRIPTION="Handwriting notetaking software with PDF annotation support"
HOMEPAGE="https://github.com/xournalpp/xournalpp"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug sound test wayland"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	${LUA_DEPS}
	app-text/poppler[cairo]
	app-text/qpdf
	>=dev-libs/glib-2.32.0
	dev-libs/libxml2:=
	>=dev-libs/libzip-1.0.1:=
	>=gnome-base/librsvg-2.40
	virtual/zlib:=
	>=x11-libs/gtk+-3.18.9:3[wayland?,X]
	>=x11-libs/gtksourceview-4.0
	debug? ( dev-cpp/cpptrace )
	sound? ( >=media-libs/portaudio-12[cxx]
		 >=media-libs/libsndfile-1.0.25 )
"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"
BDEPEND="
	virtual/pkgconfig
	sys-apps/lsb-release
	test? ( dev-cpp/gtest )
"

PATCHES=(
	"${FILESDIR}/${PN}-1.1.1-nostrip.patch"
	"${FILESDIR}/${PN}-1.2.8-lua.patch"
)

src_configure() {
	local mycmakeargs=(
		-DLUA_VERSION="$(lua_get_version)"
		-DMAN_COMPRESS=OFF
		-DENABLE_AUDIO=$(usex sound)
		-DENABLE_GTEST=$(usex test)
		-DENABLE_CPPTRACE=$(usex debug)
		-DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
	)

	# bug 957673
	use wayland || append-flags -DGENTOO_GTK_HIDE_WAYLAND

	cmake_src_configure
}

src_test() {
	# https://github.com/xournalpp/xournalpp/tree/master/test#problems-running-make-test
	eninja -C "${BUILD_DIR}" test-units
	cmake_src_test
}
