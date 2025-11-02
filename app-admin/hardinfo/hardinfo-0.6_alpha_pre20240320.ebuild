# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg cmake

GIT_COMMIT="4c97625c5666fa5fc353e7cab322b09159e54ed4"

DESCRIPTION="System information and benchmark tool for Linux systems"
HOMEPAGE="https://github.com/lpereira/hardinfo"
SRC_URI="https://github.com/lpereira/hardinfo/archive/${GIT_COMMIT}.tar.gz -> ${P}-${GIT_COMMIT}.tar.gz"

S="${WORKDIR}/${PN}-${GIT_COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc64 ~riscv x86"
IUSE="debug"

RDEPEND="dev-libs/glib:2
	dev-libs/json-glib
	sys-libs/zlib
	x11-libs/cairo
	>=x11-libs/gtk+-3.0:3"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/hardinfo-0.6-fix-function-declarations.patch )

src_configure() {
	# Only used for update checking. Revisit when switching to hardinfo2.
	sed -i -e '/LIBSOUP/d' CMakeLists.txt || die

	local mycmakeargs=(
		-DHARDINFO_GTK3=1
		-DHARDINFO_DEBUG=$(usex debug 1 0)
	)
	cmake_src_configure
}
