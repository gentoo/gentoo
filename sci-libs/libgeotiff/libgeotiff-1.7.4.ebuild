# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"

inherit cmake docs

DESCRIPTION="Library for reading TIFF files with embedded tags for geographic information"
HOMEPAGE="
	https://trac.osgeo.org/geotiff/
	https://github.com/OSGeo/libgeotiff/tree/master/libgeotiff
"
SRC_URI="https://download.osgeo.org/geotiff/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/5"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc ppc64 ~riscv x86 ~x64-macos"
# TODO: add tiff when resolved: https://github.com/OSGeo/libgeotiff/issues/125
IUSE="jpeg zlib"

DEPEND="
	>=sci-libs/proj-6.0.0:=
	>=media-libs/tiff-3.9.1:=
	jpeg? ( media-libs/libjpeg-turbo:= )
	zlib? ( virtual/zlib:= )
"
RDEPEND="${DEPEND}"
BDEPEND=">=media-libs/tiff-3.9.1"
# Upstream DOCS are a mess, install the bare minimum
DOCS=( NEWS README )

src_configure() {
	# in >1.7.3 there is BUILD_{DOC,MAN}, it should be added
	local mycmakeargs=(
		-DBUILD_MAN=ON # 12K
		-DBUILD_DOC=OFF # installs AUTHORS, COPYING...
		-DWITH_TOWGS84=ON # default
		-DWITH_UTILITIES=ON # default

		-DWITH_JPEG=$(usex jpeg)
		-DWITH_TIFF=ON # bug 837287
		-DWITH_ZLIB=$(usex zlib)
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc; then # use our Doxyfile, upstream violates the sandbox
		mkdir -p docs/api || die
		ln -s "${FILESDIR}"/Doxyfile ./ || die
		doxygen -u Doxyfile || die "updating doxygen config failed"
	fi
	docs_compile
}

src_test() {
	# https://github.com/OSGeo/libgeotiff?tab=readme-ov-file#testing
	# Check if still needed: https://github.com/OSGeo/libgeotiff/issues/126
	pushd "${BUILD_DIR}"/bin || die

	# prepare file
	./makegeo || die "makegeo failed"
	[[ -f "newgeo.tif" ]] || die "makegeo did not produce a file"

	# test
	./listgeo newgeo.tif > metadata.txt || die "listgeo metadata extraction failed"
	./geotifcp -g metadata.txt newgeo.tif newer.tif > /dev/null || die
	cmp new{geo,er}.tif || die "geotifcp produces different files"
	popd || die
}
