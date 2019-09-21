# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="An OCR Engine, orginally developed at HP, now open source."
HOMEPAGE="https://github.com/tesseract-ocr"
SRC_URI="https://github.com/tesseract-ocr/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc jpeg opencl openmp png static-libs tiff training webp"

COMMON_DEPEND=">=media-libs/leptonica-1.74:=[zlib,tiff?,jpeg?,png?,webp?]
	opencl? (
		virtual/opencl
		media-libs/tiff:0=
		media-libs/leptonica:=[tiff]
	)
	training? (
		dev-libs/icu:=
		x11-libs/pango:=
		x11-libs/cairo:=
	)"
RDEPEND="${COMMON_DEPEND}
	|| (
		>=app-text/tessdata_fast-4.0.0
		>=app-text/tessdata_best-4.0.0
		>=app-text/tessdata_legacy-4.0.0
	)"
DEPEND="${COMMON_DEPEND}
	app-text/asciidoc
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	doc? ( app-doc/doxygen )"

DOCS=( AUTHORS ChangeLog README.md )

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# scrollview disabled for now, see bug #686944
	local myeconfargs=(
		--enable-shared
		--disable-graphics
		$(use_enable opencl)
		$(use_enable openmp)
		$(use_enable static-libs static)
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	default
	use doc && emake doc
	use training && emake training
}

src_install() {
	use doc && HTML_DOCS=( doc/html/. )
	default

	find "${D}" -name '*.la' -type f -delete || die

	if use training; then
		emake DESTDIR="${D}" training-install
	fi
}
