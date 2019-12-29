# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

MY_P=${P/_rc/RC}

DESCRIPTION="Library for reading TIFF files with embedded tags for geographic information"
HOMEPAGE="http://geotiff.osgeo.org/"
SRC_URI="http://download.osgeo.org/geotiff/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ia64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="debug doc static-libs"

RDEPEND="
	virtual/jpeg:=
	>=media-libs/tiff-3.9.1:0
	sci-libs/proj:=
	sys-libs/zlib"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/${MY_P/RC*/}

DOCS=( README ChangeLog )

src_prepare() {
	default
	sed -i \
		-e "s:-O3::g" \
		configure.ac || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--enable-debug=$(usex debug) \
		--with-jpeg="${EPREFIX}"/usr/ \
		--with-zip="${EPREFIX}"/usr/

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
	default

	use doc && dohtml docs/api/*
	find "${D}" -name '*.la' -delete || die
}
