# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit meson python-single-r1 vala

DESCRIPTION="VIPS Image Processing Library"
HOMEPAGE="https://libvips.github.io/libvips/"
SRC_URI="https://github.com/libvips/libvips/releases/download/v${PV}/${P}.tar.xz"

LICENSE="LGPL-2.1+ MIT"
SLOT="0/42" # soname
KEYWORDS="~amd64 ~x86"
IUSE="
	deprecated doc exif fftw fits fontconfig graphicsmagick gsf gtk-doc heif
	imagemagick imagequant +introspection +jpeg jpeg2k jpegxl lcms matio
	openexr +orc pango pdf +png python svg test tiff vala webp
"
REQUIRED_USE="
	fontconfig? ( pango )
	graphicsmagick? ( imagemagick )
	python? ( ${PYTHON_REQUIRED_USE} )
	test? ( jpeg png webp )
	vala? ( introspection )
"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/glib:2
	dev-libs/expat
	virtual/libintl
	exif? ( media-libs/libexif )
	fftw? ( sci-libs/fftw:3.0= )
	fits? ( sci-libs/cfitsio:= )
	fontconfig? ( media-libs/fontconfig )
	gsf? ( gnome-extra/libgsf:= )
	heif? ( media-libs/libheif:= )
	imagemagick? (
		graphicsmagick? ( media-gfx/graphicsmagick:= )
		!graphicsmagick? ( media-gfx/imagemagick:= )
	)
	imagequant? ( media-gfx/libimagequant )
	introspection? ( dev-libs/gobject-introspection )
	jpeg? ( media-libs/libjpeg-turbo:= )
	jpeg2k? ( media-libs/openjpeg:= )
	jpegxl? ( media-libs/libjxl )
	lcms? ( media-libs/lcms:2 )
	matio? ( sci-libs/matio:= )
	openexr? ( media-libs/openexr:= )
	orc? ( dev-lang/orc )
	pango? (
		x11-libs/cairo
		x11-libs/pango
	)
	pdf? (
		app-text/poppler[cairo]
		x11-libs/cairo
	)
	png? ( media-libs/libpng:= )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep 'dev-python/pycairo[${PYTHON_USEDEP}]')
	)
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
		app-doc/doxygen
		media-gfx/graphviz
	)
	gtk-doc? ( dev-util/gtk-doc )
	python? ( ${PYTHON_DEPS} )
	vala? ( $(vala_depend) )
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	use vala && vala_setup

	sed -i "s/'vips-doc'/'${PF}'/" cplusplus/meson.build || die

	sed -i "/subdir('fuzz')/d" meson.build || die
}

src_configure() {
	local emesonargs=(
		$(meson_use deprecated)
		$(meson_use doc doxygen)
		-Dexamples=false
		$(meson_use gtk-doc gtk_doc)
		$(meson_use introspection)
		$(meson_use vala vapi)
		-Dcgif=disabled # not packaged, and not used to view gif (only saving)
		$(meson_feature exif)
		$(meson_feature fftw)
		$(meson_feature fits cfitsio)
		$(meson_feature fontconfig)
		$(meson_feature gsf)
		$(meson_feature heif)
		$(meson_feature imagemagick magick)
		-Dmagick-package=$(usex graphicsmagick GraphicsMagick MagickCore)
		$(meson_feature imagequant)
		$(meson_feature jpeg)
		$(meson_feature jpeg2k openjpeg)
		$(meson_feature jpegxl jpeg-xl)
		$(meson_feature lcms)
		$(meson_feature matio)
		-Dnifti=disabled # not packaged
		$(meson_feature openexr)
		-Dopenslide=disabled # not packaged
		$(meson_feature orc)
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

	if use python; then
		python_fix_shebang "${ED}"/usr/bin/vipsprofile
	else
		rm -- "${ED}"/usr/{bin/vipsprofile,share/man/man1/vipsprofile.1} || die
	fi
}
