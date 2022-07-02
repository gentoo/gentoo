# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Upstream only support 5.3 (see CMakeLists.txt), also bug #854615
LUA_COMPAT=( lua5-3 )
inherit cmake lua-single xdg

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

REQUIRED_USE="${LUA_REQUIRED_USE}"

COMMON_DEPEND="
	${LUA_DEPS}
	app-text/poppler[cairo]
	dev-libs/glib
	dev-libs/libxml2
	dev-libs/libzip:=
	gnome-base/librsvg
	media-libs/portaudio[cxx]
	media-libs/libsndfile
	sys-libs/zlib:=
	x11-libs/gtk+:3
"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"
BDEPEND="
	virtual/pkgconfig
	sys-apps/lsb-release
	elibc_musl? ( sys-libs/libbacktrace )
"

PATCHES=(
	"${FILESDIR}/${PN}-1.1.1-nostrip.patch"
	"${FILESDIR}/${PN}-1.1.1-nocompress.patch"
)
