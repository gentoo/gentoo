# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

# vala and introspection support is broken, bug #468208
VALA_USE_DEPEND=vapigen

inherit autotools gnome2-utils python-any-r1 vala

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/gegl.git"
	SRC_URI=""
else
	SRC_URI="http://download.gimp.org/pub/${PN}/${PV:0:3}/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
fi

DESCRIPTION="A graph based image processing framework"
HOMEPAGE="http://www.gegl.org/"

LICENSE="|| ( GPL-3+ LGPL-3 )"
SLOT="0.4"

IUSE="cairo cpu_flags_x86_mmx cpu_flags_x86_sse debug ffmpeg +introspection jpeg2k lcms lensfun openexr raw sdl svg test tiff umfpack vala v4l webp"
REQUIRED_USE="
	svg? ( cairo )
	vala? ( introspection )
"

# NOTE: Even current libav 11.4 does not have AV_CODEC_CAP_VARIABLE_FRAME_SIZE
#       so there is no chance to support libav right now (Gentoo bug #567638)
#       If it returns, please check prior GEGL ebuilds for how libav was integrated.  Thanks!
RDEPEND="
	>=dev-libs/glib-2.44:2
	dev-libs/json-glib
	>=media-libs/babl-0.1.54
	sys-libs/zlib
	>=x11-libs/gdk-pixbuf-2.32:2
	x11-libs/pango

	cairo? ( >=x11-libs/cairo-1.12.2 )
	ffmpeg? (
		>=media-video/ffmpeg-2.8:0=
	)
	introspection? ( >=dev-libs/gobject-introspection-1.32:= )
	virtual/jpeg:0=
	jpeg2k? ( >=media-libs/jasper-1.900.1:= )
	lcms? ( >=media-libs/lcms-2.8:2 )
	lensfun? ( >=media-libs/lensfun-0.2.5 )
	openexr? ( =media-libs/openexr-2.2*:= )
	>=media-libs/libpng-1.6.0:0=
	raw? ( >=media-libs/libraw-0.15.4:0= )
	sdl? ( >=media-libs/libsdl-1.2.0 )
	svg? ( >=gnome-base/librsvg-2.40.6:2 )
	tiff? ( >=media-libs/tiff-4:0 )
	umfpack? ( sci-libs/umfpack )
	v4l? ( >=media-libs/libv4l-1.0.1 )
	webp? ( >=media-libs/libwebp-0.5.0:= )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1
	>=sys-devel/gettext-0.19.8
	dev-lang/perl
	virtual/pkgconfig
	>=sys-devel/libtool-2.2
	test? ( ffmpeg? ( media-libs/gexiv2 )
		introspection? (
		$(python_gen_any_dep '>=dev-python/pygobject-3.2[${PYTHON_USEDEP}]') ) )
	vala? ( $(vala_depend) )
"

pkg_setup() {
	use test && use introspection && python-any-r1_pkg_setup
}

PATCHES=(
	"${FILESDIR}"/${PN}-0.3.12-failing-tests.patch
)

src_prepare() {
	default

	# FIXME: the following should be proper patch sent to upstream
	# fix OSX loadable module filename extension
	sed -i -e 's/\.dylib/.bundle/' configure.ac || die
	# don't require Apple's OpenCL on versions of OSX that don't have it
	if [[ ${CHOST} == *-darwin* && ${CHOST#*-darwin} -le 9 ]] ; then
		sed -i -e 's/#ifdef __APPLE__/#if 0/' gegl/opencl/* || die
	fi

	# commit 7c78497b : tests that use gegl.png are broken on non-amd64
	sed -e '/clones.xml/d' \
		-e '/composite-transform.xml/d' \
		-i tests/compositions/Makefile.am || die

	eautoreconf

	gnome2_environment_reset

	use vala && vala_src_prepare
}

_use_with_both() {
	if use "$1" && use "$2"; then
		echo "--with-$3"
	else
		echo "--without-$3"
	fi
}

src_configure() {
	# never enable altering of CFLAGS via profile option
	# libspiro: not in portage main tree
	# disable documentation as the generating is bit automagic
	#    if anyone wants to work on it just create bug with patch

	# Also please note that:
	#
	#  - Some auto-detections are not patched away since the docs are
	#    not built (--disable-docs, lack of --enable-gtk-doc) and these
	#    tools affect re-generation of docs, only
	#    (e.g. ruby, asciidoc, dot (of graphviz), enscript)
	#
	#  - Parameter --with-exiv2 compiles a noinst-app only, no use
	#    but needed during testing
	#
	#  - Parameter --disable-workshop disables any use of Lua, effectivly
	#
	#  - v4l support does not work with our media-libs/libv4l-0.8.9,
	#    upstream bug at https://bugzilla.gnome.org/show_bug.cgi?id=654675
	#
	#  - There are two checks for dot, one controllable by --with(out)-graphviz
	#    which toggles HAVE_GRAPHVIZ that is not used anywhere.  Yes.
	#
	#  - mrg is not in tree and gexiv2 support only has effect when mrg support
	#    is enabled
	#
	# So that's why USE="exif graphviz lua v4l" got resolved.  More at:
	# https://bugs.gentoo.org/show_bug.cgi?id=451136
	#
	econf \
		--disable-docs \
		--disable-profile \
		--disable-silent-rules \
		--disable-workshop \
		--program-suffix=-${SLOT} \
		--with-gdk-pixbuf \
		--with-pango \
		--without-libspiro \
		$(use_enable cpu_flags_x86_mmx mmx) \
		$(use_enable cpu_flags_x86_sse sse) \
		$(use_enable debug) \
		$(use_with cairo) \
		$(use_with cairo pangocairo) \
		--without-exiv2 \
		$(use_with ffmpeg libavformat) \
		$(_use_with_both ffmpeg test gexiv2) \
		--without-graphviz \
		$(use_with jpeg2k jasper) \
		$(use_with lcms) \
		$(use_with lensfun) \
		--without-lua \
		--without-mrg \
		$(use_with openexr) \
		$(use_with raw libraw) \
		$(use_with sdl) \
		$(use_with svg librsvg) \
		$(use_with tiff libtiff) \
		$(use_with umfpack) \
		$(use_with v4l libv4l) \
		$(use_with v4l libv4l2) \
		$(use_enable introspection) \
		$(use_with vala) \
		$(use_with webp)
}

src_compile() {
	default

	[[ ${PV} == *9999* ]] && emake ./ChangeLog  # "./" prevents "Circular ChangeLog <- ChangeLog dependency dropped."
}

src_install() {
	default
	prune_libtool_files --all
}
