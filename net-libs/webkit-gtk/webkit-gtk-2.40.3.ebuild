# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_REQ_USE="xml(+)"
PYTHON_COMPAT=( python3_{9..12} )
USE_RUBY="ruby30 ruby31 ruby32"

inherit check-reqs flag-o-matic gnome2 optfeature python-any-r1 ruby-single toolchain-funcs cmake

MY_P="webkitgtk-${PV}"
DESCRIPTION="Open source web browser engine"
HOMEPAGE="https://www.webkitgtk.org"
SRC_URI="https://www.webkitgtk.org/releases/${MY_P}.tar.xz"

LICENSE="LGPL-2+ BSD"
SLOT="4/37" # soname version of libwebkit2gtk-4.0
KEYWORDS="amd64 arm arm64 ~loong ~ppc ppc64 ~riscv ~sparc x86"

IUSE="aqua avif examples gamepad gles2-only keyring +gstreamer +introspection pdf +jpeg2k +jumbo-build lcms seccomp spell systemd wayland X"
REQUIRED_USE="|| ( aqua wayland X )"

# Tests do not run when built from tarballs
# https://bugs.webkit.org/show_bug.cgi?id=215986
RESTRICT="test"

# Dependencies found at Source/cmake/OptionsGTK.cmake
# Missing WebRTC support, but ENABLE_MEDIA_STREAM/ENABLE_WEB_RTC is
# experimental upstream (PRIVATE OFF) and shouldn't be used yet in 2.30
# >=gst-plugins-opus-1.14.4-r1 for opusparse (required by MSE)
# TODO: gst-plugins-base[X] is only needed when build configuration ends up
#       with GLX set, but that's a bit automagic too to fix
RDEPEND="
	>=x11-libs/cairo-1.16.0[X?]
	>=media-libs/fontconfig-2.13.0:1.0
	>=media-libs/freetype-2.9.0:2
	>=dev-libs/libgcrypt-1.7.0:0=
	>=x11-libs/gtk+-3.22.0:3[aqua?,introspection?,wayland?,X?]
	>=media-libs/harfbuzz-1.4.2:=[icu(+)]
	>=dev-libs/icu-61.2:=
	media-libs/libjpeg-turbo:0=
	>=media-libs/libepoxy-1.4.0
	>=net-libs/libsoup-2.54:2.4[introspection?]
	>=dev-libs/libxml2-2.8.0:2
	>=media-libs/libpng-1.4:0=
	dev-db/sqlite:3
	sys-libs/zlib:0
	>=app-accessibility/at-spi2-core-2.46.0:2
	media-libs/libwebp:=

	>=dev-libs/glib-2.70.0:2
	>=dev-libs/libxslt-1.1.7
	media-libs/woff2
	keyring? ( app-crypt/libsecret )
	introspection? ( >=dev-libs/gobject-introspection-1.59.1:= )
	dev-libs/libtasn1:=
	spell? ( >=app-text/enchant-0.22:2 )
	gstreamer? (
		>=media-libs/gstreamer-1.20:1.0
		>=media-libs/gst-plugins-base-1.20:1.0[egl,X?]
		gles2-only? ( media-libs/gst-plugins-base:1.0[gles2] )
		!gles2-only? ( media-libs/gst-plugins-base:1.0[opengl] )
		>=media-plugins/gst-plugins-opus-1.20:1.0
		>=media-libs/gst-plugins-bad-1.20:1.0
	)

	X? (
		x11-libs/libX11
		x11-libs/libXcomposite
		x11-libs/libXdamage
		x11-libs/libXrender
		x11-libs/libXt
	)

	dev-libs/hyphen
	jpeg2k? ( >=media-libs/openjpeg-2.2.0:2= )
	avif? ( >=media-libs/libavif-0.9.0:= )
	lcms? ( media-libs/lcms:2 )

	media-libs/mesa
	media-libs/libglvnd
	wayland? (
		dev-libs/wayland
		>=dev-libs/wayland-protocols-1.12
		>=gui-libs/libwpe-1.5.0:1.0
		>=gui-libs/wpebackend-fdo-1.7.0:1.0
	)

	seccomp? (
		>=sys-apps/bubblewrap-0.3.1
		sys-libs/libseccomp
		sys-apps/xdg-dbus-proxy
	)

	systemd? ( sys-apps/systemd:= )
	gamepad? ( >=dev-libs/libmanette-0.2.4 )
"
DEPEND="${RDEPEND}"
# Need real bison, not yacc
BDEPEND="
	${PYTHON_DEPS}
	${RUBY_DEPS}
	>=app-accessibility/at-spi2-core-2.5.3
	dev-util/gdbus-codegen
	dev-util/glib-utils
	>=dev-util/gperf-3.0.1
	dev-util/unifdef
	>=sys-devel/bison-2.4.3
	|| ( >=sys-devel/gcc-7.3 >=sys-devel/clang-5 )
	sys-devel/gettext
	virtual/pkgconfig

	>=dev-lang/perl-5.10
	virtual/perl-Data-Dumper
	virtual/perl-Carp
	virtual/perl-JSON-PP
"

S="${WORKDIR}/${MY_P}"

CHECKREQS_DISK_BUILD="18G" # and even this might not be enough, bug #417307

pkg_pretend() {
	if [[ ${MERGE_TYPE} != "binary" ]] ; then
		if is-flagq "-g*" && ! is-flagq "-g*0" ; then
			einfo "Checking for sufficient disk space to build ${PN} with debugging CFLAGS"
			check-reqs_pkg_pretend
		fi

		if ! test-flag-CXX -std=c++17 ; then
			die "You need at least GCC 7.3.x or Clang >= 5 for C++17-specific compiler flags"
		fi
	fi
}

pkg_setup() {
	if [[ ${MERGE_TYPE} != "binary" ]] && is-flagq "-g*" && ! is-flagq "-g*0" ; then
		check-reqs_pkg_setup
	fi

	python-any-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	gnome2_src_prepare
}

src_configure() {
	# Respect CC, otherwise fails on prefix #395875
	tc-export CC

	# It does not compile on alpha without this in LDFLAGS
	# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=648761
	use alpha && append-ldflags "-Wl,--no-relax"

	# ld segfaults on ia64 with LDFLAGS --as-needed, bug #555504
	use ia64 && append-ldflags "-Wl,--no-as-needed"

	# Sigbuses on SPARC with mcpu and co., bug #???
	use sparc && filter-flags "-mvis"

	# https://bugs.webkit.org/show_bug.cgi?id=42070 , #301634
	use ppc64 && append-flags "-mminimal-toc"

	# Try to use less memory, bug #469942 (see Fedora .spec for reference)
	# --no-keep-memory doesn't work on ia64, bug #502492
	if ! use ia64; then
		append-ldflags $(test-flags-CCLD "-Wl,--no-keep-memory")
	fi

	# Ruby situation is a bit complicated. See bug 513888
	local rubyimpl
	local ruby_interpreter=""
	local RUBY
	for rubyimpl in ${USE_RUBY}; do
		if has_version -b "virtual/rubygems[ruby_targets_${rubyimpl}(-)]"; then
			RUBY="$(type -P ${rubyimpl})"
			ruby_interpreter="-DRUBY_EXECUTABLE=${RUBY}"
		fi
	done
	# This will rarely occur. Only a couple of corner cases could lead us to
	# that failure. See bug 513888
	[[ -z ${ruby_interpreter} ]] && die "No suitable ruby interpreter found"
	# JavaScriptCore/Scripts/postprocess-asm invokes another Ruby script directly
	# so it doesn't respect RUBY_EXECUTABLE, bug #771744.
	sed -i -e "s:#!/usr/bin/env ruby:#!${RUBY}:" $(grep -rl "/usr/bin/env ruby" Source/JavaScriptCore || die) || die

	# TODO: Check Web Audio support
	# should somehow let user select between them?

	local mycmakeargs=(
		-DPython_EXECUTABLE="${PYTHON}"
		${ruby_interpreter}
		$(cmake_use_find_package gles2-only OpenGLES2)
		$(cmake_use_find_package !gles2-only OpenGL)
		# If bubblewrap[suid] then portage makes it go-r and cmake find_program fails with that
		-DBWRAP_EXECUTABLE:FILEPATH="${EPREFIX}"/usr/bin/bwrap
		-DDBUS_PROXY_EXECUTABLE:FILEPATH="${EPREFIX}"/usr/bin/xdg-dbus-proxy
		-DPORT=GTK
		# Source/cmake/WebKitFeatures.cmake
		-DENABLE_API_TESTS=OFF
		-DENABLE_BUBBLEWRAP_SANDBOX=$(usex seccomp)
		-DENABLE_GAMEPAD=$(usex gamepad)
		-DENABLE_MINIBROWSER=$(usex examples)
		-DENABLE_PDFJS=$(usex pdf)
		-DENABLE_GEOLOCATION=ON # Runtime optional (talks over dbus service)
		-DENABLE_SPELLCHECK=$(usex spell)
		-DENABLE_UNIFIED_BUILDS=$(usex jumbo-build)
		-DENABLE_VIDEO=$(usex gstreamer)
		-DUSE_GSTREAMER_WEBRTC=$(usex gstreamer)
		-DUSE_GSTREAMER_TRANSCODER=$(usex gstreamer)
		-DENABLE_WEBDRIVER=OFF # Disable WebDriver for webkit2gtk-4.0 and use the webkit2gtk-4.1
		-DENABLE_WEBGL=ON
		-DENABLE_WEB_AUDIO=$(usex gstreamer)
		-DUSE_AVIF=$(usex avif)
		# Source/cmake/OptionsGTK.cmake
		-DENABLE_GLES2=$(usex gles2-only)
		-DENABLE_DOCUMENTATION=OFF
		-DENABLE_INTROSPECTION=$(usex introspection)
		-DENABLE_JOURNALD_LOG=$(usex systemd)
		-DENABLE_QUARTZ_TARGET=$(usex aqua)
		-DENABLE_WAYLAND_TARGET=$(usex wayland)
		-DENABLE_X11_TARGET=$(usex X)
		-DUSE_GBM=ON
		-DUSE_GTK4=OFF
		-DUSE_JPEGXL=OFF
		-DUSE_LCMS=$(usex lcms)
		-DUSE_LIBHYPHEN=ON
		-DUSE_LIBSECRET=$(usex keyring)
		-DUSE_OPENGL_OR_ES=ON
		-DUSE_OPENJPEG=$(usex jpeg2k)
		-DUSE_SOUP2=ON
		-DUSE_WOFF2=ON
	)

	# https://bugs.gentoo.org/761238
	append-cppflags -DNDEBUG

	WK_USE_CCACHE=NO cmake_src_configure
}

pkg_postinst() {
	optfeature "geolocation service (used at runtime if available)" "app-misc/geoclue"
	optfeature "Common Multimedia codecs" "media-plugins/gst-plugins-meta"
	optfeature "(MPEG-)DASH support" "media-plugins/gst-plugins-dash"
	optfeature "HTTP-Live-Streaming support" "media-plugins/gst-plugins-hls"
}
