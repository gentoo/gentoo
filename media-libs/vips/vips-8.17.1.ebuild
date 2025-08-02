# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit flag-o-matic meson python-any-r1 toolchain-funcs vala

DESCRIPTION="VIPS Image Processing Library"
HOMEPAGE="https://libvips.github.io/libvips/"
SRC_URI="https://github.com/libvips/libvips/releases/download/v${PV}/${P}.tar.xz"

LICENSE="LGPL-2.1+ MIT"
SLOT="0/42" # soname
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="
	archive deprecated doc exif fftw fits fontconfig graphicsmagick
	heif +highway imagemagick imagequant +introspection +jpeg jpeg2k
	jpegxl lcms matio openexr orc pango pdf +png svg test tiff vala
	webp
"
REQUIRED_USE="
	doc? ( introspection )
	fontconfig? ( pango )
	graphicsmagick? ( imagemagick )
	test? ( jpeg png webp )
	vala? ( introspection )
"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/glib:2
	dev-libs/expat
	virtual/libintl
	archive? ( app-arch/libarchive:= )
	exif? ( media-libs/libexif )
	fftw? ( sci-libs/fftw:3.0= )
	fits? ( sci-libs/cfitsio:= )
	fontconfig? ( media-libs/fontconfig )
	heif? ( media-libs/libheif:= )
	highway? ( >=dev-cpp/highway-1.0.5 )
	!highway? (
		orc? ( dev-lang/orc )
	)
	imagemagick? (
		graphicsmagick? ( media-gfx/graphicsmagick:= )
		!graphicsmagick? ( media-gfx/imagemagick:= )
	)
	imagequant? ( media-gfx/libimagequant )
	introspection? ( dev-libs/gobject-introspection )
	jpeg? ( media-libs/libjpeg-turbo:= )
	jpeg2k? ( media-libs/openjpeg:= )
	jpegxl? ( media-libs/libjxl:= )
	lcms? ( media-libs/lcms:2 )
	matio? ( sci-libs/matio:= )
	openexr? ( media-libs/openexr:= )
	pango? (
		x11-libs/cairo
		x11-libs/pango
	)
	pdf? (
		app-text/poppler[cairo]
		x11-libs/cairo
	)
	png? ( media-libs/libpng:= )
	svg? (
		gnome-base/librsvg:2
		sys-libs/zlib:=
		x11-libs/cairo
	)
	tiff? ( media-libs/tiff:= )
	webp? ( media-libs/libwebp:= )
"
DEPEND="
	${RDEPEND}
	pango? ( x11-base/xorg-proto )
	pdf? ( x11-base/xorg-proto )
	svg? ( x11-base/xorg-proto )
	test? (
		tiff? ( media-libs/tiff[jpeg] )
	)
"
BDEPEND="
	dev-util/glib-utils
	sys-devel/gettext
	doc? (
		${PYTHON_DEPS}
		app-text/doxygen
		dev-util/gi-docgen
		media-gfx/graphviz
	)
	vala? ( $(vala_depend) )
"

pkg_setup() {
	use doc && python-any-r1_pkg_setup
}

src_prepare() {
	default

	use vala && vala_setup

	sed -i "/subdir('fuzz')/d" meson.build || die
}

src_configure() {
	# workaround for bug in lld (bug #921728)
	tc-ld-is-lld && filter-lto

	local emesonargs=(
		$(meson_use deprecated)
		$(meson_use doc cpp-docs)
		$(meson_use doc docs)
		-Dexamples=false
		$(meson_use vala vapi)
		-Dcgif=disabled # not packaged, and not used to view gif (only saving)
		$(meson_feature archive)
		$(meson_feature exif)
		$(meson_feature fftw)
		$(meson_feature fits cfitsio)
		$(meson_feature fontconfig)
		$(meson_feature heif)
		$(meson_feature highway)
		$(meson_feature imagemagick magick)
		-Dmagick-package=$(usex graphicsmagick GraphicsMagick MagickCore)
		$(meson_feature imagequant)
		$(meson_feature introspection)
		$(meson_feature jpeg)
		$(meson_feature jpeg2k openjpeg)
		$(meson_feature jpegxl jpeg-xl)
		$(meson_feature lcms)
		$(meson_feature matio)
		-Dnifti=disabled # not packaged
		$(meson_feature openexr)
		-Dopenslide=disabled # not packaged
		$(meson_feature orc) # no-op if USE=highway is set
		$(meson_feature pango pangocairo)
		-Dpdfium=disabled # not packaged, can use poppler instead
		$(meson_feature png)
		$(meson_feature pdf poppler)
		-Dquantizr=disabled # not packaged, can use imagequant instead
		-Dspng=disabled # not packaged, can use libpng instead
		$(meson_feature svg rsvg)
		$(meson_feature tiff)
		$(meson_feature webp)
		$(meson_feature svg zlib) # zlib is currently only used by svgload.c
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	if use doc; then
		mkdir -p "${ED}"/usr/share/doc/${PF}/html || die
		mv -- "${ED}"/usr/share/doc/{vips,${PF}/html/vips} || die
		mv -- "${ED}"/usr/share/doc/{vips-cpp/html,${PF}/html/vips-cpp} || die
		rmdir -- "${ED}"/usr/share/doc/vips-cpp || die
	fi

	# examples are disabled but the man page still gets installed
	rm -- "${ED}"/usr/share/man/man1/vipsprofile.1 || die
}
