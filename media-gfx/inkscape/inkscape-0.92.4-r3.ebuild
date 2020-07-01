# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"
inherit autotools flag-o-matic gnome2-utils xdg toolchain-funcs python-single-r1

MY_P="${P/_/}"

DESCRIPTION="SVG based generic vector-drawing program"
HOMEPAGE="https://inkscape.org/"
SRC_URI="https://inkscape.global.ssl.fastly.net/media/resources/file/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ppc ppc64 x86"
IUSE="cdr dia dbus exif gnome imagemagick openmp postscript inkjar jpeg latex"
IUSE+=" lcms nls spell static-libs visio wpg uniconvertor"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="${PYTHON_DEPS}
	>=app-text/poppler-0.26.0:=[cairo]
	>=dev-cpp/glibmm-2.54.1
	>=dev-cpp/gtkmm-2.18.0:2.4
	>=dev-cpp/cairomm-1.9.8
	>=dev-libs/boehm-gc-7.1:=
	>=dev-libs/glib-2.28
	>=dev-libs/libsigc++-2.0.12
	>=dev-libs/libxml2-2.6.20
	>=dev-libs/libxslt-1.0.15
	dev-libs/popt
	media-gfx/potrace
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/libpng:0=
	sci-libs/gsl:=
	x11-libs/libX11
	>=x11-libs/gtk+-2.10.7:2
	>=x11-libs/pango-1.24
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
		app-text/gtkspell:2
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
"
# These only use executables provided by these packages
# See share/extensions for more details. inkscape can tell you to
# install these so we could of course just not depend on those and rely
# on that.
RDEPEND="${COMMON_DEPEND}
	$(python_gen_cond_dep '
		|| (
			dev-python/numpy-python2[${PYTHON_MULTI_USEDEP}]
			dev-python/numpy[${PYTHON_MULTI_USEDEP}]
		)
	')
	uniconvertor? ( media-gfx/uniconvertor )
	dia? ( app-office/dia )
	latex? (
		media-gfx/pstoedit[plotutils]
		app-text/dvipsk
		app-text/texlive-core
	)
	postscript? ( app-text/ghostscript-gpl )
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/boost-1.36
	dev-util/glib-utils
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-0.92.1-automagic.patch"
	"${FILESDIR}/${PN}-0.91_pre3-cppflags.patch"
	"${FILESDIR}/${PN}-0.92.1-desktop.patch"
	"${FILESDIR}/${PN}-0.91_pre3-exif.patch"
	"${FILESDIR}/${PN}-0.91_pre3-sk-man.patch"
	"${FILESDIR}/${PN}-0.48.4-epython.patch"
	"${FILESDIR}/${PN}-0.92.4-poppler-0.76.0.patch" #684246
	"${FILESDIR}/${PN}-0.92.4-poppler-0.82.0.patch"
	"${FILESDIR}/${PN}-0.92.4-poppler-0.83.0.patch"
	"${FILESDIR}/${PN}-0.92.4-glibmm-2.62.patch" #715394
)

S="${WORKDIR}/${MY_P}"

RESTRICT="test"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]] && use openmp; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

src_prepare() {
	default

	sed -i "s#@EPYTHON@#${EPYTHON}#" \
		src/extension/implementation/script.cpp || die

	eautoreconf

	# bug 421111
	python_fix_shebang share/extensions
}

src_configure() {
	# aliasing unsafe wrt #310393
	append-flags -fno-strict-aliasing

	local myeconfargs=(
		$(use_enable static-libs static)
		$(use_enable nls)
		$(use_enable openmp)
		$(use_enable exif)
		$(use_enable jpeg)
		$(use_enable lcms)
		--enable-poppler-cairo
		$(use_enable wpg)
		$(use_enable visio)
		$(use_enable cdr)
		$(use_enable dbus dbusapi)
		$(use_enable imagemagick magick)
		$(use_with gnome gnome-vfs)
		$(use_with inkjar)
		$(use_with spell gtkspell)
		$(use_with spell aspell)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	emake -C src helper/sp-marshal.h #686304
	emake AR="$(tc-getAR)"
}

src_install() {
	default

	find "${ED}" -name "*.la" -delete || die
	python_optimize "${ED%/}"/usr/share/${PN}/extensions
}
