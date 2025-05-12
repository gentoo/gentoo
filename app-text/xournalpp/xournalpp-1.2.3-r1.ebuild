# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-3 lua5-4 )
inherit cmake lua-single xdg

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/xournalpp/xournalpp.git"
else
	SRC_URI="https://github.com/xournalpp/xournalpp/archive/refs/tags/v${PV}.tar.gz -> ${P}.tgz"
	KEYWORDS="amd64 ~ppc64"
fi

DESCRIPTION="Handwriting notetaking software with PDF annotation support"
HOMEPAGE="https://github.com/xournalpp/xournalpp"

LICENSE="GPL-2"
SLOT="0"

REQUIRED_USE="${LUA_REQUIRED_USE}"

COMMON_DEPEND="
	${LUA_DEPS}
	app-text/poppler[cairo]
	>=dev-libs/glib-2.32.0
	dev-libs/libxml2
	>=dev-libs/libzip-1.0.1:=
	>=gnome-base/librsvg-2.40
	>=media-libs/portaudio-12[cxx]
	>=media-libs/libsndfile-1.0.25
	sys-libs/zlib:=
	>=x11-libs/gtk+-3.18.9:3
	>=x11-libs/gtksourceview-4.0
"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"
BDEPEND="
	virtual/pkgconfig
	sys-apps/lsb-release
"

PATCHES=(
	"${FILESDIR}/${PN}-1.1.1-nostrip.patch"
	"${FILESDIR}/${PN}-1.2.3-nocompress.patch"
	"${FILESDIR}/${PN}-1.2.3-lua-5-4.patch"
)

src_configure() {
	local mycmakeargs=(
		-DLUA_VERSION="$(lua_get_version)"
	)

	cmake_src_configure
}
