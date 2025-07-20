# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_REQ_USE="xml(+)"
PYTHON_COMPAT=( python3_{10..13} )
USE_RUBY="ruby31 ruby32 ruby33 ruby34"

inherit check-reqs flag-o-matic gnome2 optfeature python-any-r1 ruby-single toolchain-funcs cmake

MY_P="webkitgtk-${PV}"
DESCRIPTION="Open source web browser engine"
HOMEPAGE="https://www.webkitgtk.org"
SRC_URI="https://www.webkitgtk.org/releases/${MY_P}.tar.xz"

S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2+ BSD"
SLOT="4.1/0" # soname version of libwebkit2gtk-4.1
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

IUSE="aqua avif examples gamepad keyring +gstreamer +introspection pdf jpegxl +jumbo-build lcms seccomp spell systemd wayland X"
REQUIRED_USE="|| ( aqua wayland X )"

# Tests do not run when built from tarballs
# https://bugs.webkit.org/show_bug.cgi?id=215986
RESTRICT="test"

# Dependencies can be found in Source/cmake/OptionsGTK.cmake.
#
# * Missing WebRTC support, but ENABLE_WEB_RTC is experimental upstream.
#
# * media-libs/mesa dep is for libgbm
#
# * >=gst-plugins-opus-1.14.4-r1 for opusparse (required by MSE)
#
# * TODO: gst-plugins-base[X] is only needed when build configuration ends up
#         with GLX set, but that's a bit automagic too to fix
#
# * Cairo is only needed on big-endian systems, where Skia is not officially
#   supported (the build system will choose a backend for you). We could probably
#   hard-code a list of BE arches here, to avoid the extra dependency? But I am
#   holding out hope that this might actually get fixed before we need to do that.
#
# * dev-util/sysprof-capture is disabled because it was a new dependency in 2.46
#   and we don't need any more new problems.
#
RDEPEND="
	app-accessibility/at-spi2-core:2
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/hyphen
	dev-libs/icu:=
	dev-libs/libgcrypt:0=
	dev-libs/libtasn1:=
	dev-libs/libxml2:2
	dev-libs/libxslt
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	media-libs/harfbuzz:=[icu(+)]
	media-libs/libjpeg-turbo:0=
	media-libs/libepoxy[egl(+)]
	media-libs/libglvnd
	media-libs/libpng:0=
	media-libs/libwebp:=
	media-libs/mesa
	media-libs/woff2
	net-libs/libsoup:3.0[introspection?]
	sys-libs/zlib:0
	x11-libs/cairo[X?]
	x11-libs/gtk+:3[aqua?,introspection?,wayland?,X?]
	x11-libs/libdrm
	avif? ( media-libs/libavif:= )
	gamepad? ( dev-libs/libmanette )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0[egl,opengl,X?]
		media-plugins/gst-plugins-opus:1.0
		media-libs/gst-plugins-bad:1.0
	)
	introspection? ( dev-libs/gobject-introspection:= )
	jpegxl? ( media-libs/libjxl:= )
	keyring? ( app-crypt/libsecret )
	lcms? ( media-libs/lcms:2 )
	seccomp? (
		sys-apps/bubblewrap
		sys-libs/libseccomp
		sys-apps/xdg-dbus-proxy
	)
	spell? ( app-text/enchant:2 )
	systemd? ( sys-apps/systemd:= )
	X? ( x11-libs/libX11 )
	wayland? (
		dev-libs/wayland
		dev-libs/wayland-protocols
	)
"
DEPEND="${RDEPEND}"
# Need real bison, not yacc
BDEPEND="
	${PYTHON_DEPS}
	${RUBY_DEPS}
	app-accessibility/at-spi2-core
	dev-lang/perl
	dev-util/gdbus-codegen
	dev-util/glib-utils
	dev-util/gperf
	dev-util/unifdef
	sys-devel/bison
	sys-devel/gettext
	virtual/pkgconfig
	wayland? ( dev-util/wayland-scanner )
"

CHECKREQS_DISK_BUILD="18G" # and even this might not be enough, bug #417307

# We cannot use PATCHES because src_prepare() calls cmake_src_prepare and
# gnome2_src_prepare, and both apply ${PATCHES[@]}
PATCHES=()

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

	# https://bugs.gentoo.org/938162, see also mycmakeargs
	eapply "${FILESDIR}"/2.48.3-fix-ftbfs-riscv64.patch

	# We don't want -Werror for gobject-introspection (bug #947761)
	sed -i -e "s:--warn-error::" Source/cmake/FindGI.cmake || die
}

src_configure() {
	# Respect CC, otherwise fails on prefix #395875
	tc-export CC

	# ODR violations (bug #915230, https://bugs.webkit.org/show_bug.cgi?id=233007)
	filter-lto

	# It does not compile on alpha without this in LDFLAGS
	# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=648761
	use alpha && append-ldflags "-Wl,--no-relax"

	# Sigbuses on SPARC with mcpu and co., bug #???
	use sparc && filter-flags "-mvis"

	# https://bugs.webkit.org/show_bug.cgi?id=42070 , #301634
	use ppc64 && append-flags "-mminimal-toc"

	# Try to use less memory, bug #469942 (see Fedora .spec for reference)
	append-ldflags $(test-flags-CCLD "-Wl,--no-keep-memory")

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
		# If bubblewrap[suid] then portage makes it go-r and cmake find_program fails with that
		-DBWRAP_EXECUTABLE:FILEPATH="${EPREFIX}"/usr/bin/bwrap
		-DDBUS_PROXY_EXECUTABLE:FILEPATH="${EPREFIX}"/usr/bin/xdg-dbus-proxy
		-DPORT=GTK
		# Source/cmake/WebKitFeatures.cmake
		-DENABLE_API_TESTS=OFF
		-DENABLE_BUBBLEWRAP_SANDBOX=$(usex seccomp)
		-DENABLE_DRAG_SUPPORT=ON
		-DENABLE_GAMEPAD=$(usex gamepad)
		-DENABLE_GEOLOCATION=ON # Runtime optional (talks over dbus service)
		-DENABLE_MINIBROWSER=$(usex examples)
		-DENABLE_PDFJS=$(usex pdf)
		-DENABLE_SPEECH_SYNTHESIS=OFF
		-DENABLE_SPELLCHECK=$(usex spell)
		-DENABLE_TOUCH_EVENTS=ON
		-DENABLE_UNIFIED_BUILDS=$(usex jumbo-build)
		-DENABLE_VIDEO=$(usex gstreamer)
		-DENABLE_WEB_AUDIO=$(usex gstreamer)
		-DENABLE_WEB_CODECS=$(usex gstreamer) # https://bugs.webkit.org/show_bug.cgi?id=269147
		-DENABLE_WEBDRIVER=OFF
		-DENABLE_WEBGL=ON
		-DUSE_AVIF=$(usex avif)
		-DUSE_GSTREAMER_WEBRTC=$(usex gstreamer)
		-DUSE_GSTREAMER_TRANSCODER=$(usex gstreamer)
		# Source/cmake/OptionsGTK.cmake
		-DENABLE_DOCUMENTATION=OFF
		-DENABLE_INTROSPECTION=$(usex introspection)
		-DENABLE_JOURNALD_LOG=$(usex systemd)
		-DENABLE_QUARTZ_TARGET=$(usex aqua)
		-DENABLE_WAYLAND_TARGET=$(usex wayland)
		-DENABLE_X11_TARGET=$(usex X)
		-DUSE_GBM=ON
		-DUSE_GTK4=OFF
		-DUSE_JPEGXL=$(usex jpegxl)
		-DUSE_LCMS=$(usex lcms)
		-DUSE_LIBBACKTRACE=OFF
		-DUSE_LIBDRM=ON
		-DUSE_LIBHYPHEN=ON
		-DUSE_LIBSECRET=$(usex keyring)
		-DUSE_SOUP2=OFF
		-DUSE_SYSPROF_CAPTURE=OFF
		-DUSE_WOFF2=ON
	)

	# Temporary workaround for bug 938162 (upstream bug 271371)
	# in concert with our Debian patch. The idea to enable C_LOOP
	# is also stolen from Debian's build.
	use riscv && mycmakeargs+=(
		-DENABLE_WEBASSEMBLY=OFF
		-DENABLE_JIT=OFF
		-DENABLE_C_LOOP=ON
	)

	# https://bugs.gentoo.org/761238
	append-cppflags -DNDEBUG

	WK_USE_CCACHE=NO cmake_src_configure
}

pkg_postinst() {
	optfeature "geolocation service (used at runtime if available)" "app-misc/geoclue"
	optfeature "Common Multimedia codecs" "media-plugins/gst-plugins-meta"
	optfeature "VAAPI encoding support" "media-libs/gst-plugins-bad[vaapi]"
	optfeature "MPEG-DASH support" "media-plugins/gst-plugins-dash"
	optfeature "HTTP live streaming (HLS) support" "media-plugins/gst-plugins-hls"
}
