# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Library for reading TIFF files with embedded tags for geographic information"
HOMEPAGE="https://trac.osgeo.org/geotiff/ https://github.com/OSGeo/libgeotiff"
SRC_URI="https://download.osgeo.org/geotiff/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/5"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="doc jpeg +tiff zlib"

DEPEND=">=sci-libs/proj-6.0.0:=
	jpeg? ( virtual/jpeg:= )
	tiff? ( >=media-libs/tiff-3.9.1 )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}"
BDEPEND="doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.1-gnuinstalldirs.patch
)

src_configure() {
	local mycmakeargs=(
		-DWITH_JPEG=$(usex jpeg)
		-DWITH_TIFF=$(usex tiff)
		-DWITH_ZLIB=$(usex zlib)
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc; then
		mkdir -p docs/api || die
		cp "${FILESDIR}"/Doxyfile Doxyfile || die
		doxygen -u Doxyfile || die "updating doxygen config failed"
		doxygen Doxyfile || die "docs generation failed"
	fi
}

src_install() {
	use doc && local HTML_DOCS=( docs/api/. )

	cmake_src_install
}
