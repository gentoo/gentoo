# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

WANT_AUTOMAKE=1.11  # see bug 471990, comment 3
# vala and introspection support is broken, bug #468208
#VALA_MIN_API_VERSION=0.14
#VALA_USE_DEPEND=vapigen

inherit versionator gnome2-utils eutils autotools #vala

DESCRIPTION="A graph based image processing framework"
HOMEPAGE="http://www.gegl.org/"
SRC_URI="https://download.gimp.org/pub/${PN}/${PV:0:3}/${P}.tar.bz2"

LICENSE="|| ( GPL-3 LGPL-3 )"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 ~hppa ia64 ~mips ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"

IUSE="cairo debug ffmpeg jpeg lensfun libav cpu_flags_x86_mmx openexr png raw sdl cpu_flags_x86_sse svg umfpack" # +introspection vala

RDEPEND="
	>=media-libs/babl-0.1.10
	>=dev-libs/glib-2.28:2
	>=x11-libs/gdk-pixbuf-2.18:2
	x11-libs/pango
	sys-libs/zlib
	cairo? ( x11-libs/cairo )
	ffmpeg? (
		libav? ( >=media-video/libav-12:0= )
		!libav? ( >=media-video/ffmpeg-4:0= )
	)
	jpeg? ( virtual/jpeg:0 )
	openexr? ( media-libs/openexr )
	png? ( media-libs/libpng:0= )
	raw? ( >=media-libs/libopenraw-0.1:0= )
	sdl? ( media-libs/libsdl )
	svg? ( >=gnome-base/librsvg-2.14:2 )
	umfpack? ( sci-libs/umfpack )
	lensfun? ( >=media-libs/lensfun-0.2.5 )
"
#	>=media-libs/babl-0.1.10[introspection?]
#	introspection? ( >=dev-libs/gobject-introspection-0.10
#			>=dev-python/pygobject-2.26:2 )
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40.1
	dev-lang/perl
	virtual/pkgconfig
	>=sys-devel/libtool-2.2
"
#	vala? ( $(vala_depend) )"

DOCS=( ChangeLog INSTALL README NEWS )

PATCHES=(
	# https://bugs.gentoo.org/show_bug.cgi?id=636780
	"${FILESDIR}/${P}-ffmpeg-av_frame_alloc.patch"

	# https://bugs.gentoo.org/show_bug.cgi?id=442016
	"${FILESDIR}/${P}-cve-2012-4433-1e92e523.patch"
	"${FILESDIR}/${P}-cve-2012-4433-4757cdf7.patch"

	# https://bugs.gentoo.org/show_bug.cgi?id=416587
	"${FILESDIR}/${P}-introspection-version.patch"

	"${FILESDIR}/${P}-ffmpeg-0.11.diff"
	"${FILESDIR}"/${P}-g_log_domain.patch

	# https://bugs.gentoo.org/show_bug.cgi?id=605216
	# https://bugs.gentoo.org/show_bug.cgi?id=617430
	"${FILESDIR}"/${P}-underlinking.patch
	"${FILESDIR}"/${P}-libopenraw-0.1.patch  # bug 639834
	"${FILESDIR}"/${P}-fix-without-exiv2.patch  # bug 641872

	"${FILESDIR}"/${P}-ffmpeg-4-0-compat.patch  # bug 673378
)

src_prepare() {
	default
	# fix OSX loadable module filename extension
	sed -i -e 's/\.dylib/.bundle/' configure.ac || die
	# don't require Apple's OpenCL on versions of OSX that don't have it
	if [[ ${CHOST} == *-darwin* && ${CHOST#*-darwin} -le 9 ]] ; then
		sed -i -e 's/#ifdef __APPLE__/#if 0/' gegl/opencl/* || die
	fi

	eautoreconf

	# https://bugs.gentoo.org/show_bug.cgi?id=468248
	local deps_file="${PN}/${PN}-$(get_version_component_range 1-2).deps"
	[[ -f "${deps_file}" ]] || touch "${deps_file}"

#	use vala && vala_src_prepare
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
	#
	#  - Parameter --disable-workshop disables any use of Lua, effectivly
	#
	#  - v4l support does not work with our media-libs/libv4l-0.8.9,
	#    upstream bug at https://bugzilla.gnome.org/show_bug.cgi?id=654675
	#
	#  - There are two checks for dot, one controllable by --with(out)-graphviz
	#    which toggles HAVE_GRAPHVIZ that is not used anywhere.  Yes.
	#
	# So that's why USE="exif graphviz lua v4l" got resolved.  More at:
	# https://bugs.gentoo.org/show_bug.cgi?id=451136
	#
	econf \
		--disable-silent-rules \
		--disable-profile \
		--without-libspiro \
		--disable-docs --disable-workshop \
		--with-pango --with-gdk-pixbuf \
		$(use_enable cpu_flags_x86_mmx mmx) \
		$(use_enable cpu_flags_x86_sse sse) \
		$(use_enable debug) \
		$(use_with cairo) \
		$(use_with cairo pangocairo) \
		--without-exiv2 \
		$(use_with ffmpeg libavformat) \
		--without-graphviz \
		$(use_with jpeg libjpeg) \
		--without-jasper \
		--without-lua \
		$(use_with openexr) \
		$(use_with png libpng) \
		$(use_with raw libopenraw) \
		$(use_with sdl) \
		$(use_with svg librsvg) \
		$(use_with umfpack) \
		--without-libv4l \
		$(use_with lensfun) \
		--disable-introspection \
		--without-vala
#		$(use_enable introspection) \
#		$(use_with vala)
}

src_test() {
	gnome2_environment_reset  # sandbox issues
	default
}

src_compile() {
	gnome2_environment_reset  # sandbox issues (bug #396687)
	default
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete
}
