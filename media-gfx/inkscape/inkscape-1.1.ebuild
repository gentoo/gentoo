# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9} )
PYTHON_REQ_USE="xml"

inherit cmake flag-o-matic xdg toolchain-funcs python-single-r1

DESCRIPTION="SVG based generic vector-drawing program"
HOMEPAGE="https://inkscape.org/"
SRC_URI="
	https://media.inkscape.org/dl/resources/file/${P}.tar.xz
	https://dev.gentoo.org/~dilfridge/distfiles/inkscape-1.1-musl.txz
"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="cdr dbus dia exif graphicsmagick imagemagick inkjar jemalloc jpeg
openmp postscript readline spell static-libs svg2 visio wpg"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="
	dev-util/glib-utils
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"
COMMON_DEPEND="${PYTHON_DEPS}
	>=app-text/poppler-0.57.0:=[cairo]
	>=dev-cpp/cairomm-1.12:0
	>=dev-cpp/glibmm-2.54.1:2
	dev-cpp/gtkmm:3.0
	>=dev-cpp/pangomm-2.40:1.4
	>=dev-libs/boehm-gc-7.1:=
	dev-libs/double-conversion:=
	>=dev-libs/glib-2.41
	>=dev-libs/libsigc++-2.8:2
	>=dev-libs/libxml2-2.7.4
	>=dev-libs/libxslt-1.1.25
	dev-libs/gdl:3
	dev-libs/popt
	media-gfx/potrace
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/lcms:2
	media-libs/libpng:0=
	net-libs/libsoup:2.4
	sci-libs/gsl:=
	x11-libs/libX11
	>=x11-libs/pango-1.37.2
	x11-libs/gtk+:3
	$(python_gen_cond_dep '
		dev-python/lxml[${PYTHON_USEDEP}]
		media-gfx/scour[${PYTHON_USEDEP}]
	')
	cdr? (
		app-text/libwpg:0.3
		dev-libs/librevenge
		media-libs/libcdr
	)
	dbus? ( dev-libs/dbus-glib )
	exif? ( media-libs/libexif )
	imagemagick? (
		!graphicsmagick? ( media-gfx/imagemagick:=[cxx] )
		graphicsmagick? ( media-gfx/graphicsmagick:=[cxx] )
	)
	jemalloc? ( dev-libs/jemalloc )
	jpeg? ( virtual/jpeg:0 )
	readline? ( sys-libs/readline:= )
	spell? ( app-text/gspell )
	visio? (
		app-text/libwpg:0.3
		dev-libs/librevenge
		media-libs/libvisio
	)
	wpg? (
		app-text/libwpg:0.3
		dev-libs/librevenge
	)
"
# These only use executables provided by these packages
# See share/extensions for more details. inkscape can tell you to
# install these so we could of course just not depend on those and rely
# on that.
RDEPEND="${COMMON_DEPEND}
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
	')
	dia? ( app-office/dia )
	postscript? ( app-text/ghostscript-gpl )
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/boost-1.65
"

RESTRICT="test"

S="${WORKDIR}/${P}_2021-05-24_c4e8f9ed74"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]] && use openmp; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

src_prepare() {
	# Backport from master
	eapply "${WORKDIR}/inkscape-1.1-musl/"*.patch
	eapply "${FILESDIR}"/${P}-poppler-21.11.0.patch

	cmake_src_prepare
	sed -i "/install.*COPYING/d" CMakeScripts/ConfigCPack.cmake || die
}

src_configure() {
	# aliasing unsafe wrt #310393
	append-flags -fno-strict-aliasing

	local mycmakeargs=(
		# -DWITH_LPETOOL   # Compile with LPE Tool and experimental LPEs enabled
		-DWITH_NLS=ON
		-DENABLE_POPPLER=ON
		-DENABLE_POPPLER_CAIRO=ON
		-DWITH_PROFILING=OFF
		-DBUILD_TESTING=OFF
		-DWITH_LIBCDR=$(usex cdr)
		-DWITH_DBUS=$(usex dbus)
		-DWITH_IMAGE_MAGICK=$(usex imagemagick $(usex !graphicsmagick)) # requires ImageMagick 6, only IM must be enabled
		-DWITH_GRAPHICS_MAGICK=$(usex graphicsmagick $(usex imagemagick)) # both must be enabled to use GraphicsMagick
		-DWITH_GNU_READLINE=$(usex readline)
		-DWITH_GSPELL=$(usex spell)
		-DWITH_JEMALLOC=$(usex jemalloc)
		-DENABLE_LCMS=ON
		-DWITH_OPENMP=$(usex openmp)
		-DBUILD_SHARED_LIBS=$(usex !static-libs)
		-DWITH_SVG2=$(usex svg2)
		-DWITH_LIBVISIO=$(usex visio)
		-DWITH_LIBWPG=$(usex wpg)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	find "${ED}" -type f -name "*.la" -delete || die

	find "${ED}"/usr/share/man -type f -maxdepth 3 -name '*.bz2' -exec bzip2 -d {} \; || die

	find "${ED}"/usr/share/man -type f -maxdepth 3 -name '*.gz' -exec gzip -d {} \; || die

	local extdir="${ED}"/usr/share/${PN}/extensions

	if [[ -e "${extdir}" ]] && [[ -n $(find "${extdir}" -mindepth 1) ]]; then
		python_optimize "${ED}"/usr/share/${PN}/extensions
	fi

	# Empty directory causes sandbox issues, see bug #761915
	rm -r "${ED}/usr/share/inkscape/fonts" || die "Failed to remove fonts directory."
}
