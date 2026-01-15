# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="create an APNG from multiple PNG files"
HOMEPAGE="https://github.com/apngasm/apngasm"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-libs/boost:=
	media-libs/libpng:0=
	virtual/zlib:=
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-3.1.10-static.patch"
	"${FILESDIR}/${PN}-3.1.10-boost-1.89.patch"
)

src_prepare() {
	sed -i -e 's|man/man1|share/man/man1|g' cli/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DLIB_INSTALL_DIR=$(get_libdir)
		-DJAVA=OFF
		-DRUBY=OFF
	)
	cmake_src_configure
}
