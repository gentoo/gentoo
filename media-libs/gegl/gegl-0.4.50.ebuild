# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
# vala and introspection support is broken, bug #468208
VALA_USE_DEPEND=vapigen

inherit flag-o-matic meson optfeature python-any-r1 toolchain-funcs vala

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/gegl.git"
	SRC_URI=""
else
	SRC_URI="https://download.gimp.org/pub/${PN}/${PV:0:3}/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="A graph based image processing framework"
HOMEPAGE="https://gegl.org/"

LICENSE="|| ( GPL-3+ LGPL-3 )"
SLOT="0.4"

IUSE="cairo debug ffmpeg introspection lcms lensfun openexr openmp pdf raw sdl sdl2 svg test tiff umfpack vala v4l webp"
REQUIRED_USE="
	svg? ( cairo )
	test? ( introspection )
	vala? ( introspection )
"

RESTRICT="!test? ( test )"

# NOTE: Even current libav 11.4 does not have AV_CODEC_CAP_VARIABLE_FRAME_SIZE
#       so there is no chance to support libav right now (Gentoo bug #567638)
#       If it returns, please check prior GEGL ebuilds for how libav was integrated.  Thanks!
RDEPEND="
	>=dev-libs/glib-2.68.2:2
	>=dev-libs/json-glib-1.2.6
	>=media-libs/babl-0.1.98[introspection?,lcms?,vala?]
	media-libs/libjpeg-turbo
	media-libs/libnsgif
	>=media-libs/libpng-1.6.0:0=
	>=sys-libs/zlib-1.2.0
	>=x11-libs/gdk-pixbuf-2.32:2
	>=x11-libs/pango-1.38.0
	cairo? ( >=x11-libs/cairo-1.12.2 )
	ffmpeg? ( media-video/ffmpeg:0= )
	introspection? ( >=dev-libs/gobject-introspection-1.32:= )
	lcms? ( >=media-libs/lcms-2.8:2 )
	lensfun? ( >=media-libs/lensfun-0.2.5 )
	openexr? ( >=media-libs/openexr-1.6.1:= )
	pdf? ( >=app-text/poppler-0.71.0[cairo] )
	raw? ( >=media-libs/libraw-0.15.4:0= )
	sdl? ( >=media-libs/libsdl-1.2.0 )
	sdl2? ( >=media-libs/libsdl2-2.0.20 )
	svg? ( >=gnome-base/librsvg-2.40.6:2 )
	tiff? ( >=media-libs/tiff-4:= )
	umfpack? ( sci-libs/umfpack )
	v4l? ( >=media-libs/libv4l-1.0.1 )
	webp? ( >=media-libs/libwebp-0.5.0:= )
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="
	${PYTHON_DEPS}
	dev-lang/perl
	>=dev-build/gtk-doc-am-1
	>=sys-devel/gettext-0.19.8
	>=dev-build/libtool-2.2
	virtual/pkgconfig
	test? ( $(python_gen_any_dep '>=dev-python/pygobject-3.2:3[${PYTHON_USEDEP}]') )
	vala? ( $(vala_depend) )
"

DOCS=( AUTHORS docs/ChangeLog docs/NEWS.adoc )

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
	sed -i -e "s/gegl-imgcmp/gegl-imgcmp-0.4/" tests/simple/test-exp-combine.sh || die
	# skip UNEXPECTED PASSED 'matting-levin' test
	sed -i -e "s/composition_tests += 'matting-levin'//" \
		-e "s/composition_tests_fail += 'matting-levin'//" tests/compositions/meson.build || die

	# don't require Apple's OpenCL on versions of OSX that don't have it
	if [[ ${CHOST} == *-darwin* && ${CHOST#*-darwin} -le 9 ]] ; then
		sed -i -e 's/#ifdef __APPLE__/#if 0/' gegl/opencl/* || die
	fi

	# fix 'build'headers from *.cl on gentoo-hardened, bug 739816
	pushd "${S}/opencl/" || die
	for file in *.cl; do
		if [[ -f ${file} ]]; then
			"${EPYTHON}" cltostring.py "${file}" || die
		fi
	done
	popd || die

	# Fix QA warning, install docs into /usr/share/gtk-doc/gegl-0.4 instead of /usr/share/doc/gegl-0.4
	sed -i -e   "s/'doc'/'gtk-doc'/" docs/reference/meson.build || die
}

src_configure() {
	# Bug #859901
	filter-lto

	use vala && vala_setup

	local emesonargs=(
		#  - Disable documentation as the generating is bit automagic
		#    if anyone wants to work on it just create bug with patch
		-Ddocs=false
		-Dexiv2=disabled
		-Dgdk-pixbuf=enabled
		-Djasper=disabled
		#  - libspiro: not in portage main tree
		-Dlibspiro=disabled
		-Dlua=disabled
		-Dmrg=disabled
		-Dpango=enabled
		#  - Parameter -Dworkshop=false disables any use of Lua, effectivly
		-Dworkshop=false
		$(meson_feature cairo)
		$(meson_feature cairo pangocairo)
		$(meson_feature ffmpeg libav)
		$(meson_feature lcms)
		$(meson_feature lensfun)
		$(meson_feature openexr)
		$(meson_feature openmp)
		$(meson_feature pdf poppler)
		$(meson_feature raw libraw)
		$(meson_feature sdl sdl1)
		$(meson_feature sdl2 sdl2)
		$(meson_feature svg librsvg)
		$(meson_feature test pygobject)
		$(meson_feature tiff libtiff)
		$(meson_feature umfpack)
		#  - v4l support does not work with our media-libs/libv4l-0.8.9,
		#    upstream bug at https://bugzilla.gnome.org/show_bug.cgi?id=654675
		$(meson_feature v4l libv4l)
		$(meson_feature v4l libv4l2)
		$(meson_feature vala vapigen)
		$(meson_feature webp)
		$(meson_use introspection)
	)
	meson_src_configure
}

pkg_postinst() {
	optfeature "'Show Image Graph' under GIMP[debug] menu 'File - Debug'" media-gfx/graphviz
}
