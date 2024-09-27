# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib-minimal toolchain-funcs

DESCRIPTION="An OCR Engine, originally developed at HP, now open source"
HOMEPAGE="https://github.com/tesseract-ocr"

if [[ "${PV}" == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/tesseract-ocr/${PN}.git"
	TESSDATA_EGIT_REPO_URI="https://github.com/egorpugin/tessdata.git"
	LANGDATA_EGIT_REPO_URI="https://github.com/tesseract-ocr/langdata_lstm.git"
	inherit git-r3
else
	TEST_COMMIT="2761899921c08014cf9dbf3b63592237fb9e6ecb" # this is version-specific, check on bump
	TESSDATA_COMMIT="fce038c79cbab4c45bac56b6f8d4e6bc6a9d9cfd" # this is arbitrary
	LANGDATA_COMMIT="07930fd9f246622c26eb5de794d9212ceac432d3" # this is arbitrary
	SRC_URI="https://github.com/tesseract-ocr/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
		test? (
			https://github.com/tesseract-ocr/test/archive/${TEST_COMMIT}.tar.gz -> tesseract-test-${TEST_COMMIT}.tar.gz
			https://github.com/egorpugin/tessdata/archive/${TESSDATA_COMMIT}.tar.gz
				-> tesseract-tessdata-${TESSDATA_COMMIT}.tar.gz
			https://github.com/tesseract-ocr/langdata_lstm/archive/${LANGDATA_COMMIT}.tar.gz
				-> tesseract-langdata-${LANGDATA_COMMIT}.tar.gz
		)"
fi

LICENSE="Apache-2.0"
SLOT="0/5"
KEYWORDS="~alpha amd64 ~arm arm64 ~mips ppc ppc64 ~riscv ~sparc x86"
IUSE="doc float32 jpeg opencl openmp png static-libs test tiff training webp"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( training )"

COMMON_DEPEND=">=media-libs/leptonica-1.74:=[${MULTILIB_USEDEP},zlib,tiff?,jpeg?,png?,webp?]
	opencl? (
		virtual/opencl[${MULTILIB_USEDEP}]
		media-libs/tiff:=[${MULTILIB_USEDEP}]
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
	doc? ( app-text/doxygen )
	test? ( dev-cpp/gtest )"
BDEPEND="test? (
	media-fonts/corefonts
)"

PATCHES=(
	"${FILESDIR}"/${PN}-5.4.1-arm64-neon-tesseract.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_unpack() {
	if [[ "${PV}" == *9999* ]]; then
		if ! use test; then
			EGIT_SUBMODULES+=( '-test' )
		else
			git-r3_fetch "${TESSDATA_EGIT_REPO_URI}"
			git-r3_checkout "${TESSDATA_EGIT_REPO_URI}" "${WORKDIR}/tessdata_checkout"
			git-r3_fetch "${LANGDATA_EGIT_REPO_URI}"
			git-r3_checkout "${LANGDATA_EGIT_REPO_URI}" "${WORKDIR}/langdata_lstm"
		fi
		git-r3_src_unpack
	else
		default
	fi
}

src_prepare() {
	if use test; then
		if [[ "${PV}" == *9999* ]]; then
			find "${WORKDIR}/tessdata_checkout/fonts" -type f -exec ln -s "{}" "${S}/test/testing/" \; || die
			mv "${WORKDIR}/tessdata_checkout/tessdata" "${WORKDIR}/" || die
			mv "${WORKDIR}/tessdata_checkout/tessdata_best" "${WORKDIR}/" || die
			mv "${WORKDIR}/tessdata_checkout/tessdata_fast" "${WORKDIR}/" || die
		else
			sed -i \
				-e "s/GTEST_LIBS = .*/GTEST_LIBS = -lgtest -lgtest_main/g" \
				-e "s/GMOCK_LIBS = .*/GMOCK_LIBS = -lgmock -lgmock_main/g" \
				-e "/check_LTLIBRARIES/d" "Makefile.am" || die
			rmdir "test" || die
			mv "${WORKDIR}/test-${TEST_COMMIT}" "${S}/test" || die
			find "${WORKDIR}/tessdata-${TESSDATA_COMMIT}/fonts" -type f -exec ln -s "{}" "${S}/test/testing/" \; || die
			mv "${WORKDIR}/tessdata-${TESSDATA_COMMIT}/tessdata" "${WORKDIR}/" || die
			mv "${WORKDIR}/tessdata-${TESSDATA_COMMIT}/tessdata_best" "${WORKDIR}/" || die
			mv "${WORKDIR}/tessdata-${TESSDATA_COMMIT}/tessdata_fast" "${WORKDIR}/" || die
			mv "${WORKDIR}/langdata_lstm-${LANGDATA_COMMIT}" "${WORKDIR}/langdata_lstm" || die
		fi
		ln -s "${EPREFIX}/usr/share/fonts/corefonts/arialbi.ttf" "${S}/test/testing/Arial_Bold_Italic.ttf" || die
		ln -s "${EPREFIX}/usr/share/fonts/corefonts/times.ttf" "${S}/test/testing/Times_New_Roman.ttf" || die
		ln -s "${EPREFIX}/usr/share/fonts/corefonts/verdana.ttf" "${S}/test/testing/Verdana.ttf" || die
	fi
	default
	eautoreconf
}

multilib_src_configure() {
	# scrollview disabled for now, see bug #686944
	local myeconfargs=(
		--enable-shared
		--disable-graphics
		$(use_enable float32)
		$(use_enable opencl)
		$(use_enable openmp)
		$(use_enable static-libs static)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	default
	if multilib_is_native_abi; then
		use doc && emake doc
		use training && emake training
	fi
}

multilib_src_install() {
	if multilib_is_native_abi; then
		DOCS=( "${S}"/AUTHORS "${S}"/ChangeLog "${S}"/README.md )
		if use doc; then
			HTML_DOCS=( doc/html/. )
		fi
		einstalldocs

		if use training; then
			emake DESTDIR="${D}" training-install
		fi
	fi
	emake DESTDIR="${D}" install
}

multilib_src_install_all() {
	find "${D}" -name '*.la' -type f -delete || die
}
