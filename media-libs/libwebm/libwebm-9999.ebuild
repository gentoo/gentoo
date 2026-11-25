# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="WebM is an open, royalty-free, media file format designed for the web"
HOMEPAGE="https://chromium.googlesource.com/webm/libwebm"

PATCHES=(
	"${FILESDIR}/soversion.patch"
)

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://chromium.googlesource.com/webm/libwebm.git"
	inherit git-r3
else
	SRC_URI="https://github.com/webmproject/libwebm/archive/refs/tags/${P}.tar.gz"
	S="${WORKDIR}/${PN}-${P}"
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0/${PV}"

src_prepare() {
	cmake_src_prepare
	sed -i -e "s/project(LIBWEBM CXX)/project(LIBWEBM LANGUAGES CXX VERSION ${PV})/g" "${S}/CMakeLists.txt" || die
}

src_configure() {
	mycmakeargs=(
		-DENABLE_TESTS=OFF
		-DENABLE_SAMPLE_PROGRAMS=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "${FILESDIR}/libwebm.pc"
	sed -i \
		-e "s/@PACKAGE_VERSION@/${PV}/g" \
		-e "s/@LIBDIR@/$(get_libdir)/g" \
		"${ED}/usr/$(get_libdir)/pkgconfig/libwebm.pc" || die
}
