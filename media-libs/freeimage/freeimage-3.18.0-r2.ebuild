# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils toolchain-funcs

MY_PN=FreeImage
MY_PV=${PV//.}
MY_P=${MY_PN}${MY_PV}

DESCRIPTION="Image library supporting many formats"
HOMEPAGE="https://freeimage.sourceforge.io/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip
	mirror://sourceforge/${PN}/${MY_P}.pdf
	https://dev.gentoo.org/~juippis/distfiles/tmp/freeimage-3.18.0-unbundling.patch"

LICENSE="|| ( GPL-2 FIPL-1.0 )"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE="jpeg jpeg2k mng openexr png raw static-libs tiff webp"

# The tiff/ilmbase isn't a typo.  The TIFF plugin cheats and
# uses code from it to handle 16bit<->float conversions.
RDEPEND="
	sys-libs/zlib
	jpeg? ( virtual/jpeg:0 )
	jpeg2k? ( media-libs/openjpeg:2= )
	mng? ( media-libs/libmng:= )
	openexr? ( media-libs/openexr:= )
	png? ( media-libs/libpng:0= )
	raw? ( media-libs/libraw:= )
	tiff? (
		media-libs/ilmbase:=
		media-libs/tiff:0
	)
	webp? ( media-libs/libwebp:= )"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/unzip
	virtual/pkgconfig"

S=${WORKDIR}/${MY_PN}

DOCS=( "${DISTDIR}"/${MY_P}.pdf README.linux Whatsnew.txt )
PATCHES=(
	"${DISTDIR}"/${PN}-3.18.0-unbundling.patch
	"${FILESDIR}"/${PN}-3.18.0-remove-jpeg-transform.patch
	"${FILESDIR}"/${PN}-3.18.0-rename-jpeg_read_icc_profile.patch
	"${FILESDIR}"/${PN}-3.18.0-disable-plugin-G3.patch
	"${FILESDIR}"/${PN}-3.18.0-raw.patch
	"${FILESDIR}"/${PN}-3.18.0-libjpeg9.patch
	"${FILESDIR}"/${PN}-3.18.0-CVE-2019-12211-CVE-2019-12213.patch
	"${FILESDIR}"/${PN}-3.18.0-libraw-0.20.0.patch
)

src_prepare() {
	pushd Source >/dev/null || die
	cp LibJPEG/{transupp.c,transupp.h,jinclude.h} . || die
	cp LibTIFF4/{tiffiop,tif_dir}.h . || die
	rm -rf LibPNG LibMNG LibOpenJPEG ZLib OpenEXR LibRawLite LibTIFF4 LibJPEG LibWebP LibJXR || die
	popd >/dev/null || die

	edos2unix Makefile.{gnu,fip,srcs} fipMakefile.srcs */*.h */*/*.cpp
	sed -i \
		-e "s:/./:/:g" \
		-e "s: ./: :g" \
		-e 's: Source: \\\n\tSource:g' \
		-e 's: Wrapper: \\\n\tWrapper:g' \
		-e 's: Examples: \\\n\tExamples:g' \
		-e 's: TestAPI: \\\n\tTestAPI:g' \
		-e 's: -ISource: \\\n\t-ISource:g' \
		-e 's: -IWrapper: \\\n\t-IWrapper:g' \
		-e 's:INCLS:\nINCLS:g' \
		Makefile.srcs fipMakefile.srcs || die
	sed -i \
		-e "/LibJPEG/d" \
		-e "/LibJXR/d" \
		-e "/LibPNG/d" \
		-e "/LibTIFF/d" \
		-e "/Source\/ZLib/d" \
		-e "/LibOpenJPEG/d" \
		-e "/OpenEXR/d" \
		-e "/LibRawLite/d" \
		-e "/LibMNG/d" \
		-e "/LibWebP/d" \
		-e "/LibJXR/d" \
		Makefile.srcs fipMakefile.srcs || die

	default
}

foreach_make() {
	local m
	for m in Makefile.{gnu,fip} ; do
		emake -f ${m} \
			USE_EXR=$(usex openexr) \
			USE_JPEG=$(usex jpeg) \
			USE_JPEG2K=$(usex jpeg2k) \
			USE_MNG=$(usex mng) \
			USE_PNG=$(usex png) \
			USE_TIFF=$(usex tiff) \
			USE_RAW=$(usex raw) \
			USE_WEBP=$(usex webp) \
			$(usex static-libs '' STATICLIB=) \
			"$@"
	done
}

src_compile() {
	tc-export AR PKG_CONFIG
	foreach_make \
		CXX="$(tc-getCXX) -fPIC" \
		CC="$(tc-getCC) -fPIC" \
		${MY_PN}
}

src_install() {
	foreach_make install DESTDIR="${ED}" INSTALLDIR="${ED}"/usr/$(get_libdir)
	einstalldocs
}
