# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6} )
PYTHON_REQ_USE="xml"

inherit cmake-utils flag-o-matic xdg-utils xdg toolchain-funcs python-single-r1

MY_P="${P/_/}"

DESCRIPTION="SVG based generic vector-drawing program"
HOMEPAGE="https://inkscape.org/"
SRC_URI="https://inkscape.org/gallery/item/14917/${MY_P}.tar.bz2"
#SRC_URI="https://inkscape.global.ssl.fastly.net/media/resources/file/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="cdr dia dbus exif gnome graphicsmagick +imagemagick openmp postscript inkjar jpeg svg2 jemalloc"
IUSE+=" lcms nls spell static-libs visio wpg"

REQUIRED_USE="${PYTHON_REQUIRED_USE} ^^ ( imagemagick graphicsmagick )"

COMMON_DEPEND="${PYTHON_DEPS}
	>=app-text/poppler-0.57.0:=[cairo]
	>=dev-cpp/glibmm-2.54.1
	>=dev-cpp/cairomm-1.12
	>=dev-libs/boehm-gc-7.1:=
	>=dev-libs/glib-2.41
	>=dev-libs/libsigc++-2.8
	>=dev-libs/libxml2-2.7.4
	>=dev-libs/libxslt-1.1.25
	dev-libs/popt
	dev-python/lxml[${PYTHON_USEDEP}]
	media-gfx/potrace
	media-gfx/scour[${PYTHON_USEDEP}]
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/libpng:0=
	sci-libs/gsl:=
	x11-libs/libX11
	>=x11-libs/pango-1.37.2
	cdr? (
		app-text/libwpg:0.3
		dev-libs/librevenge
		media-libs/libcdr
	)
	dbus? ( dev-libs/dbus-glib )
	exif? ( media-libs/libexif )
	gnome? ( >=gnome-base/gnome-vfs-2.0 )
	imagemagick? ( <media-gfx/imagemagick-7:=[cxx] )
	jpeg? ( virtual/jpeg:0 )
	lcms? ( media-libs/lcms:2 )
	spell? (
		app-text/aspell
		app-text/gtkspell:3
	)
	visio? (
		app-text/libwpg:0.3
		dev-libs/librevenge
		media-libs/libvisio
	)
	wpg? (
		app-text/libwpg:0.3
		dev-libs/librevenge
	)
	x11-libs/gtk+:3
	dev-libs/gdl:3
	dev-cpp/gtkmm:3.0
	>=dev-cpp/pangomm-2.40
	jemalloc? ( dev-libs/jemalloc )
	net-libs/libsoup
	dev-libs/double-conversion
"

# These only use executables provided by these packages
# See share/extensions for more details. inkscape can tell you to
# install these so we could of course just not depend on those and rely
# on that.
RDEPEND="${COMMON_DEPEND}
	dev-python/numpy[${PYTHON_USEDEP}]
	dia? ( app-office/dia )
	postscript? ( app-text/ghostscript-gpl )
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/boost-1.65
	dev-util/glib-utils
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_P}"

RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${P}-detect-imagemagick.patch
	"${FILESDIR}"/${P}-do-not-compress-man.patch
)

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]] && use openmp; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

src_prepare() {
	einfo "Fixing doc directory path..."
	sed -i "s%doc/inkscape%doc/${P}%g" CMakeScripts/ConfigCPack.cmake || die "Failed to fix doc directory path"

	cmake-utils_src_prepare
}

src_configure() {
	# aliasing unsafe wrt #310393
	append-flags -fno-strict-aliasing

mycmakeargs=(
	-DWITH_DBUS="$(usex dbus ON OFF)"   # Compile with support for DBus interface
	-DENABLE_LCMS="$(usex lcms ON OFF)"   # Compile with LCMS support
	-DWITH_SVG2="$(usex svg2 ON OFF)"   # Compile with support for new SVG2 features
#    -DWITH_LPETOOL   # Compile with LPE Tool and experimental LPEs enabled
	-DWITH_OPENMP="$(usex openmp ON OFF)"   # Compile with OpenMP support
#    -DWITH_PROFILING   # Turn on profiling
	-DBUILD_SHARED_LIBS="$(usex !static-libs ON OFF)"  # Compile libraries as shared and not static
	-DENABLE_POPPLER=ON   # Compile with support of libpoppler
	-DENABLE_POPPLER_CAIRO=ON   # Compile with support of libpoppler-cairo for rendering PDF preview (depends on ENABLE_POPPLER)
	-DWITH_IMAGE_MAGICK="$(usex imagemagick ON OFF)"   # Compile with support of ImageMagick for raster extensions and image import resolution (requires ImageMagick 6; set to OFF if you prefer GraphicsMagick)
	-DWITH_GRAPHICS_MAGICK="$(usex graphicsmagick ON OFF)"   # Compile with support of GraphicsMagick for raster extensions and image import resolution
	-DWITH_LIBCDR="$(usex cdr ON OFF)"   # Compile with support of libcdr for CorelDRAW Diagrams
	-DWITH_LIBVISIO="$(usex visio ON OFF)"   # Compile with support of libvisio for Microsoft Visio Diagrams
	-DWITH_LIBWPG="$(usex wpg ON OFF)"   # Compile with support of libwpg for WordPerfect Graphics
	-DWITH_NLS="$(usex nls ON OFF)"   # Compile with Native Language Support (using gettext)
	-DWITH_JEMALLOC="$(usex jemalloc ON OFF)"   # Compile with JEMALLOC support
)

	cmake-utils_src_configure
}

src_install() {
	default

	find "${ED}" -name "*.la" -delete || die

	# No extensions are present in beta1
	if [ -n $(find "${ED}"/usr/share/${PN}/extensions -mindepth 1) ]; then
		python_optimize "${ED}"/usr/share/${PN}/extensions
	fi

	cmake-utils_src_install
}

pkg_preinst() {
	xdg_icon_savelist
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
