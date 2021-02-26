# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Library for reading TIFF files with embedded tags for geographic information"
HOMEPAGE="https://trac.osgeo.org/geotiff/ https://github.com/OSGeo/libgeotiff"
SRC_URI="https://download.osgeo.org/geotiff/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/5"
KEYWORDS="amd64 ~arm arm64 ~ia64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="debug doc static-libs"

BDEPEND="
	doc? ( app-doc/doxygen )
	virtual/pkgconfig
"
DEPEND="
	>=media-libs/tiff-3.9.1:0
	>=sci-libs/proj-6.0.0:=
	sys-libs/zlib
	virtual/jpeg:=
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -e "s:-O3::g" -i configure.ac || die
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		--enable-debug=$(usex debug) \
		--with-jpeg="${EPREFIX}"/usr \
		--with-zip="${EPREFIX}"/usr
}

src_compile() {
	default

	if use doc; then
		mkdir -p docs/api || die
		cp "${FILESDIR}"/Doxyfile Doxyfile || die
		doxygen -u Doxyfile || die "updating doxygen config failed"
		doxygen Doxyfile || die "docs generation failed"
	fi
}

src_install() {
	use doc && local HTML_DOCS=( docs/api/. )

	default

	find "${D}" -name '*.la' -type f -delete || die
}
