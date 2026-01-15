# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
# vala and introspection support is broken, bug #468208
VALA_USE_DEPEND=vapigen

inherit flag-o-matic meson optfeature python-any-r1 toolchain-funcs vala

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/gegl.git"
else
	SRC_URI="https://download.gimp.org/pub/${PN}/${PV:0:3}/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="A graph based image processing framework"
HOMEPAGE="https://gegl.org/"

LICENSE="|| ( GPL-3+ LGPL-3 )"
SLOT="0.4"

IUSE="cairo debug ffmpeg gtk-doc +introspection jpeg2k lcms openexr openmp pdf raw sdl sdl2 svg test tiff umfpack vala v4l webp"
REQUIRED_USE="
	gtk-doc? ( introspection )
	svg? ( cairo )
	test? ( introspection )
	vala? ( introspection )
"

RESTRICT="!test? ( test )"

# See https://gegl.org/build.html for upstream instructions on dependencies.
RDEPEND="
	>=dev-libs/glib-2.44.0:2
	>=dev-libs/json-glib-1.0.0
	>=media-libs/babl-0.1.116[introspection?,lcms?,vala?]
	>=media-libs/libjpeg-turbo-1.0.0:=
	>=media-libs/libnsgif-1.0.0:=
	>=media-libs/libpng-1.6.0:0=
	>=virtual/zlib-1.2.0:=
	>=x11-libs/gdk-pixbuf-2.32:2
	>=x11-libs/pango-1.38.0
	cairo? ( >=x11-libs/cairo-1.12.2 )
	ffmpeg? ( media-video/ffmpeg:0= )
	introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2:= )
	jpeg2k? ( >=media-libs/jasper-1.900.1:= )
	lcms? ( >=media-libs/lcms-2.8:2 )
	openexr? ( >=media-libs/openexr-1.6.1:= )
	pdf? ( >=app-text/poppler-0.71.0[cairo] )
	raw? ( >=media-libs/libraw-0.15.4:0= )
	sdl? ( >=media-libs/libsdl-1.2.0 )
	sdl2? ( >=media-libs/libsdl2-2.0.5 )
	svg? ( >=gnome-base/librsvg-2.40.6:2 )
	tiff? ( >=media-libs/tiff-4:= )
	umfpack? ( sci-libs/umfpack )
	v4l? ( >=media-libs/libv4l-1.0.1 )
	webp? ( >=media-libs/libwebp-0.5.0:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	dev-lang/perl
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	gtk-doc? ( dev-util/gi-docgen )
	test? ( $(python_gen_any_dep '>=dev-python/pygobject-3.2:3[${PYTHON_USEDEP}]') )
	vala? ( $(vala_depend) )
"

DOCS=( AUTHORS docs/ChangeLog docs/NEWS.adoc )

PATCHES=(
	"${FILESDIR}"/gegl-0.4.66-respect-NM.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
	python-any-r1_pkg_setup
}

python_check_deps() {
	use test || return 0
	python_has_version -b ">=dev-python/pygobject-3.2:3[${PYTHON_USEDEP}]"
}

src_prepare() {
	default
	# patch executables suffix
	sed -i -e "s/'gegl'/'gegl-0.4'/" bin/meson.build || die
	sed -i -e "s/'gegl-imgcmp'/'gegl-imgcmp-0.4'/" tools/meson.build || die
	sed -i -e "s/gegl-imgcmp/gegl-imgcmp-0.4/" tests/simple/test-exp-combine.py || die
	# skip UNEXPECTED PASSED 'matting-levin' test
	sed -i -e "s/composition_tests += 'matting-levin'//" \
		-e "s/composition_tests_fail += 'matting-levin'//" tests/compositions/meson.build || die

	# don't require Apple's OpenCL on versions of OSX that don't have it
	if [[ ${CHOST} == *-darwin* && ${CHOST#*-darwin} -le 9 ]] ; then
		sed -i -e 's/#ifdef __APPLE__/#if 0/' gegl/opencl/* || die
	fi

	# Fix QA warning, install docs into /usr/share/gtk-doc/html/gegl-0.4 instead of /usr/share/doc/gegl-0.4
	sed -i -e   "s#'doc'#'gtk-doc' / 'html'#" docs/reference/meson.build || die
}

src_configure() {
	# Bug #859901
	filter-lto

	use vala && vala_setup

	local emesonargs=(
		# Follow upstream order in meson_options.txt

		# - Disable documentation as the generating is bit automagic
		#   if anyone wants to work on it just create bug with patch
		-Ddocs=false  # website
		$(meson_feature gtk-doc gi-docgen)
		# - Work in progress operations
		#   Might make sense to hook up if masked to make it an explicit opt-in
		-Dworkshop=false
		$(meson_use introspection)
		$(meson_feature vala vapigen)

		# Optional dependencies (as per upstream)
		-Dgdk-pixbuf=enabled
		# - Dependency currently used for tests, examples and not installed tools.
		#   If in addition mrg and sdl are enabled then some substantive change could happen.
		#   With ffmpeg allows building tests that currently fail bug #907412
		-Dgexiv2=disabled
		# - Noop option. Its fully optional at runtime.
		-Dgraphviz=disabled
		$(meson_feature jpeg2k jasper)
		$(meson_feature lcms)
		# - Needs -Dworkshop=true
		-Dlensfun=disabled
		$(meson_feature ffmpeg libav)
		$(meson_feature raw libraw)
		$(meson_feature svg librsvg)
		# - Not in portage main tree
		-Dlibspiro=disabled
		$(meson_feature tiff libtiff)
		# - v4l support does not work with our media-libs/libv4l-0.8.9,
		#   upstream bug at https://bugzilla.gnome.org/show_bug.cgi?id=654675
		$(meson_feature v4l libv4l)
		$(meson_feature v4l libv4l2)
		-Dlua=disabled
		# - Unpackaged and discontinued upstream. mrg upstream recommends ctx which is vendored in gegl
		-Dmrg=disabled
		# - Unpackaged, needs -Dworkshop=true
		#   Implementation of the feature in gimp stalled
		#   https://gitlab.gnome.org/GNOME/gimp/-/issues/2912
		-Dmaxflow=disabled
		$(meson_feature openexr)
		$(meson_feature openmp)
		$(meson_feature cairo)
		-Dpango=enabled
		$(meson_feature cairo pangocairo)
		$(meson_feature pdf poppler)
		# - Test dependency
		$(meson_feature test pygobject)
		$(meson_feature sdl sdl1)
		$(meson_feature sdl2 sdl2)
		$(meson_feature umfpack)
		$(meson_feature webp)
	)
	meson_src_configure
}

pkg_postinst() {
	optfeature "'Show Image Graph' under GIMP[debug] menu 'File - Debug'" media-gfx/graphviz
}
