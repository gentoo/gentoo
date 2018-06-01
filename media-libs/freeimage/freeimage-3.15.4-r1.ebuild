# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs eutils

MY_PN=FreeImage
MY_PV=${PV//.}
MY_P=${MY_PN}${MY_PV}

DESCRIPTION="Image library supporting many formats"
HOMEPAGE="http://freeimage.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip
	mirror://sourceforge/${PN}/${MY_P}.pdf"

LICENSE="|| ( GPL-2 FIPL-1.0 )"
SLOT="0"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="jpeg jpeg2k mng openexr png raw static-libs tiff"

# The tiff/ilmbase isn't a typo.  The TIFF plugin cheats and
# uses code from it to handle 16bit<->float conversions.
RDEPEND="
	sys-libs/zlib
	jpeg? ( virtual/jpeg:0 )
	jpeg2k? ( media-libs/openjpeg:0= )
	mng? ( media-libs/libmng:= )
	openexr? ( media-libs/openexr:= )
	png? ( media-libs/libpng:0= )
	raw? ( media-libs/libraw:= )
	tiff? (
		media-libs/ilmbase:=
		media-libs/tiff:0
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	app-arch/unzip"

S=${WORKDIR}/${MY_PN}

DOCS=( "${DISTDIR}"/${MY_P}.pdf README.linux Whatsnew.txt )
PATCHES=(
	"${FILESDIR}"/${PN}-3.15.4-{unbundling,raw}.patch
	"${FILESDIR}"/${PN}-3.15.4-CVE-2016-5684-1.patch
	"${FILESDIR}"/${PN}-3.15.4-CVE-2016-5684-2.patch
	"${FILESDIR}"/${PN}-3.15.4-CVE-2015-0852.patch
	"${FILESDIR}"/${PN}-3.15.4-libjpeg9.patch
)

src_prepare() {
	pushd Source >/dev/null || die
	if has_version ">=media-libs/libjpeg-turbo-1.2.1"; then
		# Patch from Christian Heimes's fork (thanks)
		# https://bitbucket.org/tiran/freeimageturbo
		eapply "${FILESDIR}"/${PN}-3.15.4-libjpeg-turbo.patch
		cp LibJPEG/{jpegcomp.h,jpegint.h} . || die
	fi
	cp LibJPEG/{transupp.c,transupp.h,jinclude.h} . || die
	cp LibTIFF4/{tiffiop,tif_dir}.h . || die
	rm -rf LibPNG LibMNG LibOpenJPEG ZLib OpenEXR LibRawLite LibTIFF4 LibJPEG || die
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
		Makefile.srcs fipMakefile.srcs || die
	sed -i \
		-e "/LibJPEG/d" \
		-e "/LibPNG/d" \
		-e "/LibTIFF/d" \
		-e "/Source\/ZLib/d" \
		-e "/LibOpenJPEG/d" \
		-e "/OpenEXR/d" \
		-e "/LibRawLite/d" \
		-e "/LibMNG/d" \
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
	foreach_make install DESTDIR="${ED}" INSTALLDIR="${ED%/}"/usr/$(get_libdir)
	einstalldocs
}
