# Copyright 2009-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# PACKAGING NOTES

# This uses a gentoo-created tarball due to Google CI Failures.
# Use 132 as a base for new official tarballs.

GN_MIN_VER=0.2165
# chromium-tools/get-chromium-toolchain-strings.py
TEST_FONT=f26f29c9d3bfae588207bbc9762de8d142e58935c62a86f67332819b15203b35

VIRTUALX_REQUIRED="pgo"

CHROMIUM_LANGS="af am ar bg bn ca cs da de el en-GB es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk ur vi zh-CN zh-TW"

LLVM_COMPAT=( 18 19 )
RUST_NEEDS_LLVM="yes please"
PYTHON_COMPAT=( python3_{11..13} )
PYTHON_REQ_USE="xml(+)"
RUST_MIN_VER=1.78.0

inherit check-reqs chromium-2 desktop flag-o-matic llvm-r1 multiprocessing ninja-utils pax-utils
inherit python-any-r1 qmake-utils readme.gentoo-r1 rust systemd toolchain-funcs virtualx xdg-utils

DESCRIPTION="Open-source version of Google Chrome web browser"
HOMEPAGE="https://www.chromium.org/"
PPC64_HASH="a85b64f07b489b8c6fdb13ecf79c16c56c560fc6"
PATCH_V="${PV%%\.*}-1"
SRC_URI="https://chromium-tarballs.distfiles.gentoo.org/${P}.tar.xz -> ${P}-gentoo.tar.xz
		https://gitlab.com/Matt.Jolly/chromium-patches/-/archive/${PATCH_V}/chromium-patches-${PATCH_V}.tar.bz2
	test? (
		https://chromium-tarballs.distfiles.gentoo.org/${P}-testdata.tar.xz -> ${P}-testdata-gentoo.tar.xz
		https://chromium-fonts.storage.googleapis.com/${TEST_FONT} -> chromium-testfonts-${TEST_FONT:0:10}.tar.gz
	)
	ppc64? (
		https://gitlab.solidsilicon.io/public-development/open-source/chromium/openpower-patches/-/archive/${PPC64_HASH}/openpower-patches-${PPC64_HASH}.tar.bz2 -> chromium-openpower-${PPC64_HASH:0:10}.tar.bz2
	)
	pgo? ( https://github.com/elkablo/chromium-profiler/releases/download/v0.2/chromium-profiler-0.2.tar )"

LICENSE="BSD"
SLOT="0/stable"
# Dev exists mostly to give devs some breathing room for beta/stable releases;
# it shouldn't be keyworded but adventurous users can select it.
if [[ ${SLOT} != "0/dev" ]]; then
	KEYWORDS="~amd64 ~arm64"
fi

IUSE_SYSTEM_LIBS="+system-harfbuzz +system-icu +system-png +system-zstd"
IUSE="+X ${IUSE_SYSTEM_LIBS} bindist cups debug ffmpeg-chromium gtk4 +hangouts headless kerberos +official pax-kernel pgo +proprietary-codecs pulseaudio"
IUSE+=" qt5 qt6 +screencast selinux test +vaapi +wayland +widevine"
RESTRICT="
	!bindist? ( bindist )
	!test? ( test )
"

REQUIRED_USE="
	!headless? ( || ( X wayland ) )
	pgo? ( X !wayland )
	qt6? ( qt5 )
	screencast? ( wayland )
	ffmpeg-chromium? ( bindist proprietary-codecs )
"

COMMON_X_DEPEND="
	x11-libs/libXcomposite:=
	x11-libs/libXcursor:=
	x11-libs/libXdamage:=
	x11-libs/libXfixes:=
	>=x11-libs/libXi-1.6.0:=
	x11-libs/libXrandr:=
	x11-libs/libXrender:=
	x11-libs/libXtst:=
	x11-libs/libxshmfence:=
"

COMMON_SNAPSHOT_DEPEND="
	system-icu? ( >=dev-libs/icu-73.0:= )
	>=dev-libs/libxml2-2.12.4:=[icu]
	dev-libs/nspr:=
	>=dev-libs/nss-3.26:=
	dev-libs/libxslt:=
	media-libs/fontconfig:=
	>=media-libs/freetype-2.11.0-r1:=
	system-harfbuzz? ( >=media-libs/harfbuzz-3:0=[icu(-)] )
	media-libs/libjpeg-turbo:=
	system-png? ( media-libs/libpng:=[-apng(-)] )
	system-zstd? ( >=app-arch/zstd-1.5.5:= )
	>=media-libs/libwebp-0.4.0:=
	media-libs/mesa:=[gbm(+)]
	>=media-libs/openh264-1.6.0:=
	sys-libs/zlib:=
	x11-libs/libdrm:=
	!headless? (
		dev-libs/glib:2
		>=media-libs/alsa-lib-1.0.19:=
		pulseaudio? ( media-libs/libpulse:= )
		sys-apps/pciutils:=
		kerberos? ( virtual/krb5 )
		vaapi? ( >=media-libs/libva-2.7:=[X?,wayland?] )
		X? (
			x11-base/xorg-proto:=
			x11-libs/libX11:=
			x11-libs/libxcb:=
			x11-libs/libXext:=
		)
		x11-libs/libxkbcommon:=
		wayland? (
			dev-libs/libffi:=
			dev-libs/wayland:=
			screencast? ( media-video/pipewire:= )
		)
	)
"

COMMON_DEPEND="
	${COMMON_SNAPSHOT_DEPEND}
	app-arch/bzip2:=
	dev-libs/expat:=
	net-misc/curl[ssl]
	sys-apps/dbus:=
	media-libs/flac:=
	sys-libs/zlib:=[minizip]
	!headless? (
		X? ( ${COMMON_X_DEPEND} )
		>=app-accessibility/at-spi2-core-2.46.0:2
		media-libs/mesa:=[X?,wayland?]
		cups? ( >=net-print/cups-1.3.11:= )
		virtual/udev
		x11-libs/cairo:=
		x11-libs/gdk-pixbuf:2
		x11-libs/pango:=
		qt5? (
			dev-qt/qtcore:5
			dev-qt/qtwidgets:5
		)
		qt6? ( dev-qt/qtbase:6[gui,widgets] )
	)
"
RDEPEND="${COMMON_DEPEND}
	!headless? (
		|| (
			x11-libs/gtk+:3[X?,wayland?]
			gui-libs/gtk:4[X?,wayland?]
		)
		qt5? ( dev-qt/qtgui:5[X?,wayland?] )
		qt6? ( dev-qt/qtbase:6[X?,wayland?] )
	)
	virtual/ttf-fonts
	selinux? ( sec-policy/selinux-chromium )
	bindist? (
		!ffmpeg-chromium? ( >=media-video/ffmpeg-6.1-r1:0/58.60.60[chromium] )
		ffmpeg-chromium? ( media-video/ffmpeg-chromium:${PV%%\.*} )
	)
"
DEPEND="${COMMON_DEPEND}
	!headless? (
		gtk4? ( gui-libs/gtk:4[X?,wayland?] )
		!gtk4? ( x11-libs/gtk+:3[X?,wayland?] )
	)
"

BDEPEND="
	${COMMON_SNAPSHOT_DEPEND}
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
	>=app-arch/gzip-1.7
	!headless? (
		qt5? ( dev-qt/qtcore:5 )
		qt6? ( dev-qt/qtbase:6 )
	)
	$(llvm_gen_dep '
		sys-devel/clang:${LLVM_SLOT}
		sys-devel/llvm:${LLVM_SLOT}
		sys-devel/lld:${LLVM_SLOT}
	')
	pgo? (
		>=dev-python/selenium-3.141.0
		>=dev-util/web_page_replay_go-20220314
	)
	>=dev-util/bindgen-0.68.0
	>=dev-build/gn-${GN_MIN_VER}
	dev-build/ninja
	dev-lang/perl
	>=dev-util/gperf-3.0.3
	dev-vcs/git
	>=net-libs/nodejs-7.6.0[inspector]
	>=sys-devel/bison-2.4.3
	sys-devel/flex
	virtual/pkgconfig
"

if ! has chromium_pkg_die ${EBUILD_DEATH_HOOKS}; then
	EBUILD_DEATH_HOOKS+=" chromium_pkg_die";
fi

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
Some web pages may require additional fonts to display properly.
Try installing some of the following packages if some characters
are not displayed properly:
- media-fonts/arphicfonts
- media-fonts/droid
- media-fonts/ipamonafont
- media-fonts/noto
- media-fonts/ja-ipafonts
- media-fonts/takao-fonts
- media-fonts/wqy-microhei
- media-fonts/wqy-zenhei

To fix broken icons on the Downloads page, you should install an icon
theme that covers the appropriate MIME types, and configure this as your
GTK+ icon theme.

For native file dialogs in KDE, install kde-apps/kdialog.

To make password storage work with your desktop environment you may
have install one of the supported credentials management applications:
- app-crypt/libsecret (GNOME)
- kde-frameworks/kwallet (KDE)
If you have one of above packages installed, but don't want to use
them in Chromium, then add --password-store=basic to CHROMIUM_FLAGS
in /etc/chromium/default.
"

python_check_deps() {
	python_has_version "dev-python/setuptools[${PYTHON_USEDEP}]"
}

pre_build_checks() {
	# Check build requirements: bugs #471810, #541816, #914220
	# We're going to start doing maths here on the size of an unpacked source tarball,
	# this should make updates easier as chromium continues to balloon in size.
	local BASE_DISK=24
	local EXTRA_DISK=1
	local CHECKREQS_MEMORY="4G"
	tc-is-cross-compiler && EXTRA_DISK=2
	if tc-is-lto || use pgo; then
		CHECKREQS_MEMORY="9G"
		tc-is-cross-compiler && EXTRA_DISK=4
		use pgo && EXTRA_DISK=8
	fi
	if is-flagq '-g?(gdb)?([1-9])'; then
		if use custom-cflags; then
			EXTRA_DISK=13
		fi
		CHECKREQS_MEMORY="16G"
	fi
	CHECKREQS_DISK_BUILD="$((BASE_DISK + EXTRA_DISK))G"
	check-reqs_${EBUILD_PHASE_FUNC}
}

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		# The pre_build_checks are all about compilation resources, no need to run it for a binpkg
		pre_build_checks
	fi

	if use headless; then
		local headless_unused_flags=("cups" "kerberos" "pulseaudio" "qt5" "qt6" "vaapi" "wayland")
		for myiuse in ${headless_unused_flags[@]}; do
			use ${myiuse} && ewarn "Ignoring USE=${myiuse}, USE=headless is set."
		done
	fi

	if ! use bindist && use ffmpeg-chromium; then
		ewarn "Ignoring USE=ffmpeg-chromium, USE=bindist is not set."
	fi
}

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		# The pre_build_checks are all about compilation resources, no need to run it for a binpkg
		pre_build_checks

		# The linux:unbundle toolchain in GN grabs CC, CXX, CPP (etc) from the environment
		# We'll set these to clang here then use llvm-utils functions to very explicitly set these
		# to a sane value.
		# This is effectively the 'force-clang' path if GCC support is re-added.
		# TODO: check if the user has already selected a specific impl via make.conf and respect that.
		use_lto="false"
		if tc-is-lto; then
			use_lto="true"
			# We can rely on GN to do this for us; anecdotally without this builds
			# take significantly longer with LTO enabled and it doesn't hurt anything.
			filter-lto
		fi

		if [ "$use_lto" = "false" ] && use official; then
			einfo "USE=official selected and LTO not detected."
			einfo "It is _highly_ recommended that LTO be enabled for performance reasons"
			einfo "and to be consistent with the upstream \"official\" build optimisations."
		fi

		if [ "$use_lto" = "false" ] && use test; then
			die "Tests require CFI which requires LTO"
		fi

		export use_lto

		# 936858
		if tc-ld-is-mold; then
			eerror "Your toolchain is using the mold linker."
			eerror "This is not supported by Chromium."
			die "Please switch to a different linker."
		fi

		# Forcing clang; user choice respected by llvm_slot_x USE
		AR=llvm-ar
		CPP="${CHOST}-clang++ -E"
		NM=llvm-nm
		CC=${CHOST}-clang
		CXX=${CHOST}-clang++

		if tc-is-cross-compiler; then
			use pgo && die "The pgo USE flag cannot be used when cross-compiling"
			CPP="${CBUILD}-clang++ -E"
		fi

		llvm-r1_pkg_setup
		rust_pkg_setup

		# I hate doing this but upstream Rust have yet to come up with a better solution for
		# us poor packagers. Required for Split LTO units, which are required for CFI.
		export RUSTC_BOOTSTRAP=1

		# Users should never hit this, it's purely a development convenience
		if ver_test $(gn --version || die) -lt ${GN_MIN_VER}; then
			die "dev-build/gn >= ${GN_MIN_VER} is required to build this Chromium"
		fi
	fi

	chromium_suid_sandbox_check_kernel_config
}

src_unpack() {
	unpack ${P}-gentoo.tar.xz
	unpack chromium-patches-${PATCH_V}.tar.bz2

	use pgo && unpack chromium-profiler-0.2.tar

	if use test; then
		# A new testdata tarball is available for each release; but testfonts tend to remain stable
		# for the duration of a release.
		# This unpacks directly into/over ${WORKDIR}/${P} so we can just use `unpack`.
		unpack ${P}-testdata-gentoo.tar.xz
		# This just contains a bunch of font files that need to be unpacked (or moved) to the correct location.
		local testfonts_dir="${WORKDIR}/${P}/third_party/test_fonts"
		local testfonts_tar="${DISTDIR}/chromium-testfonts-${TEST_FONT:0:10}.tar.gz"
		tar xf "${testfonts_tar}" -C "${testfonts_dir}" || die "Failed to unpack testfonts"
	fi

	if use ppc64; then
		unpack chromium_${PATCHSET_PPC64}.debian.tar.xz
		unpack chromium-ppc64le-gentoo-patches-1.tar.xz
	fi
}

src_prepare() {
	# Calling this here supports resumption via FEATURES=keepwork
	python_setup

	# disable global media controls, crashes with libstdc++
	sed -i -e \
		"/\"GlobalMediaControlsCastStartStop\"/,+4{s/ENABLED/DISABLED/;}" \
		"chrome/browser/media/router/media_router_feature.cc"

	local PATCHES=(
		"${FILESDIR}/chromium-cross-compile.patch"
		"${FILESDIR}/chromium-109-system-zlib.patch"
		"${FILESDIR}/chromium-111-InkDropHost-crash.patch"
		"${FILESDIR}/chromium-127-bindgen-custom-toolchain.patch"
		"${FILESDIR}/chromium-131-unbundle-icu-target.patch"
		"${FILESDIR}/chromium-131-oauth2-client-switches.patch"
		"${FILESDIR}/chromium-131-const-atomicstring-conversion.patch"
	)

	PATCHES+=( "${WORKDIR}/chromium-patches-${PATCH_V}" )
	# We can't use the bundled compiler builtins with the system toolchain
	# `grep` is a development convenience to ensure we fail early when google changes something.
	local builtins_match="if (is_clang && !is_nacl && !is_cronet_build) {"
	grep -q "${builtins_match}" build/config/compiler/BUILD.gn || die "Failed to disable bundled compiler builtins"
	sed -i -e "/${builtins_match}/,+2d" build/config/compiler/BUILD.gn

	if use ppc64 ; then
		local p
		for p in $(grep -v "^#" "${WORKDIR}"/debian/patches/series | grep "^ppc64le" || die); do
			if [[ ! $p =~ "fix-breakpad-compile.patch" ]]; then
				eapply "${WORKDIR}/debian/patches/${p}"
			fi
		done
		PATCHES+=( "${WORKDIR}/ppc64le" )
		PATCHES+=( "${WORKDIR}/debian/patches/fixes/rust-clanglib.patch" )
	fi

	default

	rm third_party/node/linux/node-linux-x64/bin/node || die
	ln -s "${EPREFIX}"/usr/bin/node third_party/node/linux/node-linux-x64/bin/node || die

	# adjust python interpreter version
	sed -i -e "s|\(^script_executable = \).*|\1\"${EPYTHON}\"|g" .gn || die

	# remove_bundled_libraries.py walks the source tree and looks for paths containing the substring 'third_party'
	# whitelist matches use the right-most matching path component, so we need to whitelist from that point down.
	local keeplibs=(
		base/third_party/cityhash
		base/third_party/double_conversion
		base/third_party/icu
		base/third_party/nspr
		base/third_party/superfasthash
		base/third_party/symbolize
		base/third_party/xdg_user_dirs
		buildtools/third_party/libc++
		buildtools/third_party/libc++abi
		chrome/third_party/mozilla_security_manager
		net/third_party/mozilla_security_manager
		net/third_party/nss
		net/third_party/quic
		net/third_party/uri_template
		third_party/abseil-cpp
		third_party/angle
		third_party/angle/src/common/third_party/xxhash
		third_party/angle/src/third_party/ceval
		third_party/angle/src/third_party/libXNVCtrl
		third_party/angle/src/third_party/volk
		third_party/anonymous_tokens
		third_party/apple_apsl
		third_party/axe-core
		third_party/bidimapper
		third_party/blink
		third_party/boringssl
		third_party/boringssl/src/third_party/fiat
		third_party/breakpad
		third_party/breakpad/breakpad/src/third_party/curl
		third_party/brotli
		third_party/catapult
		third_party/catapult/common/py_vulcanize/third_party/rcssmin
		third_party/catapult/common/py_vulcanize/third_party/rjsmin
		third_party/catapult/third_party/beautifulsoup4-4.9.3
		third_party/catapult/third_party/html5lib-1.1
		third_party/catapult/third_party/polymer
		third_party/catapult/third_party/six
		third_party/catapult/tracing/third_party/d3
		third_party/catapult/tracing/third_party/gl-matrix
		third_party/catapult/tracing/third_party/jpeg-js
		third_party/catapult/tracing/third_party/jszip
		third_party/catapult/tracing/third_party/mannwhitneyu
		third_party/catapult/tracing/third_party/oboe
		third_party/catapult/tracing/third_party/pako
		third_party/ced
		third_party/cld_3
		third_party/closure_compiler
		third_party/content_analysis_sdk
		third_party/cpuinfo
		third_party/crabbyavif
		third_party/crashpad
		third_party/crashpad/crashpad/third_party/lss
		third_party/crashpad/crashpad/third_party/zlib
		third_party/crc32c
		third_party/cros_system_api
		third_party/d3
		third_party/dav1d
		third_party/dawn
		third_party/dawn/third_party/gn/webgpu-cts
		third_party/dawn/third_party/khronos
		third_party/depot_tools
		third_party/devscripts
		third_party/devtools-frontend
		third_party/devtools-frontend/src/front_end/third_party/acorn
		third_party/devtools-frontend/src/front_end/third_party/additional_readme_paths.json
		third_party/devtools-frontend/src/front_end/third_party/axe-core
		third_party/devtools-frontend/src/front_end/third_party/chromium
		third_party/devtools-frontend/src/front_end/third_party/codemirror
		third_party/devtools-frontend/src/front_end/third_party/csp_evaluator
		third_party/devtools-frontend/src/front_end/third_party/diff
		third_party/devtools-frontend/src/front_end/third_party/i18n
		third_party/devtools-frontend/src/front_end/third_party/intl-messageformat
		third_party/devtools-frontend/src/front_end/third_party/json5
		third_party/devtools-frontend/src/front_end/third_party/lighthouse
		third_party/devtools-frontend/src/front_end/third_party/lit
		third_party/devtools-frontend/src/front_end/third_party/marked
		third_party/devtools-frontend/src/front_end/third_party/puppeteer
		third_party/devtools-frontend/src/front_end/third_party/puppeteer/package/lib/esm/third_party/mitt
		third_party/devtools-frontend/src/front_end/third_party/puppeteer/package/lib/esm/third_party/parsel-js
		third_party/devtools-frontend/src/front_end/third_party/puppeteer/package/lib/esm/third_party/rxjs
		third_party/devtools-frontend/src/front_end/third_party/third-party-web
		third_party/devtools-frontend/src/front_end/third_party/vscode.web-custom-data
		third_party/devtools-frontend/src/front_end/third_party/wasmparser
		third_party/devtools-frontend/src/front_end/third_party/web-vitals
		third_party/devtools-frontend/src/third_party
		third_party/distributed_point_functions
		third_party/dom_distiller_js
		third_party/eigen3
		third_party/emoji-segmenter
		third_party/farmhash
		third_party/fast_float
		third_party/fdlibm
		third_party/ffmpeg
		third_party/fft2d
		third_party/flatbuffers
		third_party/fp16
		third_party/freetype
		third_party/fusejs
		third_party/fxdiv
		third_party/gemmlowp
		third_party/google_input_tools
		third_party/google_input_tools/third_party/closure_library
		third_party/google_input_tools/third_party/closure_library/third_party/closure
		third_party/googletest
		third_party/highway
		third_party/hunspell
		third_party/iccjpeg
		third_party/ink_stroke_modeler/src/ink_stroke_modeler
		third_party/ink_stroke_modeler/src/ink_stroke_modeler/internal
		third_party/ink/src/ink/brush
		third_party/ink/src/ink/color
		third_party/ink/src/ink/geometry
		third_party/ink/src/ink/rendering
		third_party/ink/src/ink/rendering/skia/common_internal
		third_party/ink/src/ink/rendering/skia/native
		third_party/ink/src/ink/rendering/skia/native/internal
		third_party/ink/src/ink/strokes
		third_party/ink/src/ink/types
		third_party/inspector_protocol
		third_party/ipcz
		third_party/jinja2
		third_party/jsoncpp
		third_party/jstemplate
		third_party/khronos
		third_party/lens_server_proto
		third_party/leveldatabase
		third_party/libaddressinput
		third_party/libaom
		third_party/libaom/source/libaom/third_party/fastfeat
		third_party/libaom/source/libaom/third_party/SVT-AV1
		third_party/libaom/source/libaom/third_party/vector
		third_party/libaom/source/libaom/third_party/x86inc
		third_party/libavif
		third_party/libc++
		third_party/libevent
		third_party/libgav1
		third_party/libjingle
		third_party/libphonenumber
		third_party/libsecret
		third_party/libsrtp
		third_party/libsync
		third_party/liburlpattern
		third_party/libva_protected_content
		third_party/libvpx
		third_party/libvpx/source/libvpx/third_party/x86inc
		third_party/libwebm
		third_party/libx11
		third_party/libxcb-keysyms
		third_party/libxml/chromium
		third_party/libyuv
		third_party/libzip
		third_party/lit
		third_party/lottie
		third_party/lss
		third_party/lzma_sdk
		third_party/mako
		third_party/markupsafe
		third_party/material_color_utilities
		third_party/mesa
		third_party/metrics_proto
		third_party/minigbm
		third_party/modp_b64
		third_party/nasm
		third_party/nearby
		third_party/neon_2_sse
		third_party/node
		third_party/omnibox_proto
		third_party/one_euro_filter
		third_party/openscreen
		third_party/openscreen/src/third_party/
		third_party/openscreen/src/third_party/tinycbor/src/src
		third_party/opus
		third_party/ots
		third_party/pdfium
		third_party/pdfium/third_party/agg23
		third_party/pdfium/third_party/bigint
		third_party/pdfium/third_party/freetype
		third_party/pdfium/third_party/lcms
		third_party/pdfium/third_party/libopenjpeg
		third_party/pdfium/third_party/libtiff
		third_party/perfetto
		third_party/perfetto/protos/third_party/chromium
		third_party/perfetto/protos/third_party/simpleperf
		third_party/pffft
		third_party/ply
		third_party/polymer
		third_party/private_membership
		third_party/private-join-and-compute
		third_party/protobuf
		third_party/pthreadpool
		third_party/puffin
		third_party/pyjson5
		third_party/pyyaml
		third_party/qcms
		third_party/rapidhash
		third_party/re2
		third_party/rnnoise
		third_party/rust
		third_party/ruy
		third_party/s2cellid
		third_party/securemessage
		third_party/selenium-atoms
		third_party/sentencepiece
		third_party/sentencepiece/src/third_party/darts_clone
		third_party/shell-encryption
		third_party/simplejson
		third_party/six
		third_party/skia
		third_party/skia/include/third_party/vulkan
		third_party/skia/third_party/vulkan
		third_party/smhasher
		third_party/snappy
		third_party/spirv-headers
		third_party/spirv-tools
		third_party/sqlite
		third_party/swiftshader
		third_party/swiftshader/third_party/astc-encoder
		third_party/swiftshader/third_party/llvm-subzero
		third_party/swiftshader/third_party/marl
		third_party/swiftshader/third_party/SPIRV-Headers/include/spirv
		third_party/swiftshader/third_party/SPIRV-Tools
		third_party/swiftshader/third_party/subzero
		third_party/tensorflow_models
		third_party/tensorflow-text
		third_party/tflite
		third_party/tflite/src/third_party/eigen3
		third_party/tflite/src/third_party/fft2d
		third_party/tflite/src/third_party/xla/third_party/tsl
		third_party/tflite/src/third_party/xla/xla/tsl/framework
		third_party/tflite/src/third_party/xla/xla/tsl/lib/random
		third_party/tflite/src/third_party/xla/xla/tsl/protobuf
		third_party/tflite/src/third_party/xla/xla/tsl/util
		third_party/ukey2
		third_party/unrar
		third_party/utf
		third_party/vulkan
		third_party/wayland
		third_party/webdriver
		third_party/webgpu-cts
		third_party/webrtc
		third_party/webrtc/common_audio/third_party/ooura
		third_party/webrtc/common_audio/third_party/spl_sqrt_floor
		third_party/webrtc/modules/third_party/fft
		third_party/webrtc/modules/third_party/g711
		third_party/webrtc/modules/third_party/g722
		third_party/webrtc/rtc_base/third_party/base64
		third_party/webrtc/rtc_base/third_party/sigslot
		third_party/widevine
		third_party/woff2
		third_party/wuffs
		third_party/x11proto
		third_party/xcbproto
		third_party/xnnpack
		third_party/zlib/google
		third_party/zxcvbn-cpp
		url/third_party/mozilla
		v8/src/third_party/siphash
		v8/src/third_party/utf8-decoder
		v8/src/third_party/valgrind
		v8/third_party/glibc
		v8/third_party/inspector_protocol
		v8/third_party/v8

		# gyp -> gn leftovers
		third_party/speech-dispatcher
		third_party/usb_ids
		third_party/xdg-utils
	)

	if use test; then
		# tar tvf /var/cache/distfiles/${P}-testdata.tar.xz | grep '^d' | grep 'third_party' | awk '{print $NF}'
		keeplibs+=(
			third_party/google_benchmark/src/include/benchmark
			third_party/google_benchmark/src/src
			third_party/perfetto/protos/third_party/pprof
			third_party/test_fonts
			third_party/test_fonts/fontconfig
		)
	fi

	# USE=system-*
	if ! use system-harfbuzz; then
		keeplibs+=( third_party/harfbuzz-ng )
	fi

	if ! use system-icu; then
		keeplibs+=( third_party/icu )
	fi

	if ! use system-png; then
		keeplibs+=( third_party/libpng )
	fi

	if ! use system-zstd; then
		keeplibs+=( third_party/zstd )
	fi

	# Arch-specific
	if use arm64 || use ppc64 ; then
		keeplibs+=( third_party/swiftshader/third_party/llvm-10.0 )
	fi
	# we need to generate ppc64 stuff because upstream does not ship it yet
	# it has to be done before unbundling.
	if use ppc64; then
		pushd third_party/libvpx >/dev/null || die
		mkdir -p source/config/linux/ppc64 || die
		# requires git and clang, bug #832803
		# Revert https://chromium.googlesource.com/chromium/src/+/b463d0f40b08b4e896e7f458d89ae58ce2a27165%5E%21/third_party/libvpx/generate_gni.sh
		# and https://chromium.googlesource.com/chromium/src/+/71ebcbce867dd31da5f8b405a28fcb0de0657d91%5E%21/third_party/libvpx/generate_gni.sh
		# since we're not in a git repo
		sed -i -e "s|^update_readme||g; s|clang-format|${EPREFIX}/bin/true|g; /^git -C/d; /git cl/d; /cd \$BASE_DIR\/\$LIBVPX_SRC_DIR/ign format --in-place \$BASE_DIR\/BUILD.gn\ngn format --in-place \$BASE_DIR\/libvpx_srcs.gni" \
			generate_gni.sh || die
		./generate_gni.sh || die
		popd >/dev/null || die

		pushd third_party/ffmpeg >/dev/null || die
		cp libavcodec/ppc/h264dsp.c libavcodec/ppc/h264dsp_ppc.c || die
		cp libavcodec/ppc/h264qpel.c libavcodec/ppc/h264qpel_ppc.c || die
		popd >/dev/null || die
	fi

	# Sanity check keeplibs, on major version bumps it is often necessary to update this list
	# and this enables us to hit them all at once.
	# There are some entries that need to be whitelisted (TODO: Why? The file is understandable, the rest seem odd)
	whitelist_libs=(
		net/third_party/quic
		third_party/devtools-frontend/src/front_end/third_party/additional_readme_paths.json
		third_party/libjingle
		third_party/mesa
		third_party/skia/third_party/vulkan
		third_party/vulkan
	)
	local not_found_libs=()
	for lib in "${keeplibs[@]}"; do
		if [[ ! -d "${lib}" ]] && ! has "${lib}" "${whitelist_libs[@]}"; then
			not_found_libs+=( "${lib}" )
		fi
	done

	if [[ ${#not_found_libs[@]} -gt 0 ]]; then
		eerror "The following \`keeplibs\` directories were not found in the source tree:"
		for lib in "${not_found_libs[@]}"; do
			eerror "  ${lib}"
		done
		die "Please update the ebuild."
	fi

	# Remove most bundled libraries. Some are still needed.
	einfo "Unbundling third-party libraries ..."
	build/linux/unbundle/remove_bundled_libraries.py "${keeplibs[@]}" --do-remove || die

	# TODO: From 127 chromium includes a bunch of binaries? Unbundle them; they're not needed.

	# bundled eu-strip is for amd64 only and we don't want to pre-stripped binaries
	mkdir -p buildtools/third_party/eu-strip/bin || die
	ln -s "${EPREFIX}"/bin/true buildtools/third_party/eu-strip/bin/eu-strip || die
}

chromium_configure() {
	# Calling this here supports resumption via FEATURES=keepwork
	python_setup

	local myconf_gn=""

	# We already forced the "correct" clang via pkg_setup

	if tc-is-cross-compiler; then
		CC="${CC} -target ${CHOST} --sysroot ${ESYSROOT}"
		CXX="${CXX} -target ${CHOST} --sysroot ${ESYSROOT}"
		BUILD_AR=${AR}
		BUILD_CC=${CC}
		BUILD_CXX=${CXX}
		BUILD_NM=${NM}
	fi

	strip-unsupported-flags

	myconf_gn+=" is_clang=true clang_use_chrome_plugins=false"
	# https://bugs.gentoo.org/918897#c32
	append-ldflags -Wl,--undefined-version
	myconf_gn+=" use_lld=true"

	# Make sure the build system will use the right tools, bug #340795.
	tc-export AR CC CXX NM

	myconf_gn+=" custom_toolchain=\"//build/toolchain/linux/unbundle:default\""

	if tc-is-cross-compiler; then
		tc-export BUILD_{AR,CC,CXX,NM}
		myconf_gn+=" host_toolchain=\"//build/toolchain/linux/unbundle:host\""
		myconf_gn+=" v8_snapshot_toolchain=\"//build/toolchain/linux/unbundle:host\""
		myconf_gn+=" pkg_config=\"$(tc-getPKG_CONFIG)\""
		myconf_gn+=" host_pkg_config=\"$(tc-getBUILD_PKG_CONFIG)\""

		# setup cups-config, build system only uses --libs option
		if use cups; then
			mkdir "${T}/cups-config" || die
			cp "${ESYSROOT}/usr/bin/${CHOST}-cups-config" "${T}/cups-config/cups-config" || die
			export PATH="${PATH}:${T}/cups-config"
		fi

		# Don't inherit PKG_CONFIG_PATH from environment
		local -x PKG_CONFIG_PATH=
	else
		myconf_gn+=" host_toolchain=\"//build/toolchain/linux/unbundle:default\""
	fi

	# bindgen settings
	# From 127, to make bindgen work, we need to provide a location for libclang.
	# We patch this in for gentoo - see chromium-*-bindgen-custom-toolchain.patch
	# rust_bindgen_root = directory with `bin/bindgen` beneath it.
	myconf_gn+=" rust_bindgen_root=\"${EPREFIX}/usr/\""

	myconf_gn+=" bindgen_libclang_path=\"$(get_llvm_prefix)/$(get_libdir)\""
	# We don't need to set 'clang_base_bath' for anything in our build
	# and it defaults to the google toolchain location. Instead provide a location
	# to where system clang lives sot that bindgen can find system headers (e.g. stddef.h)
	myconf_gn+=" clang_base_path=\"${EPREFIX}/usr/lib/clang/${LLVM_SLOT}/\""

	myconf_gn+=" rust_sysroot_absolute=\"$(get_rust_prefix)\""
	myconf_gn+=" rustc_version=\"${RUST_SLOT}\""

	# GN needs explicit config for Debug/Release as opposed to inferring it from build directory.
	myconf_gn+=" is_debug=false"

	# enable DCHECK with USE=debug only, increases chrome binary size by 30%, bug #811138.
	# DCHECK is fatal by default, make it configurable at runtime, #bug 807881.
	myconf_gn+=" dcheck_always_on=$(usex debug true false)"
	myconf_gn+=" dcheck_is_configurable=$(usex debug true false)"

	# Component build isn't generally intended for use by end users. It's mostly useful
	# for development and debugging.
	myconf_gn+=" is_component_build=false"

	# Disable nacl, we can't build without pnacl (http://crbug.com/269560).
	myconf_gn+=" enable_nacl=false"

	# Use system-provided libraries.
	# TODO: freetype -- remove sources (https://bugs.chromium.org/p/pdfium/issues/detail?id=733).
	# TODO: use_system_hunspell (upstream changes needed).
	# TODO: use_system_protobuf (bug #525560).
	# TODO: use_system_sqlite (http://crbug.com/22208).

	# libevent: https://bugs.gentoo.org/593458
	local gn_system_libraries=(
		flac
		fontconfig
		freetype
		# Need harfbuzz_from_pkgconfig target
		#harfbuzz-ng
		libdrm
		libjpeg
		libwebp
		libxml
		libxslt
		openh264
		zlib
	)
	if use system-icu; then
		gn_system_libraries+=( icu )
	fi
	if use system-png; then
		gn_system_libraries+=( libpng )
	fi
	if use system-zstd; then
		gn_system_libraries+=( zstd )
	fi

	build/linux/unbundle/replace_gn_files.py --system-libraries "${gn_system_libraries[@]}" || die

	# TODO 131: The above call clobbers `enable_freetype = true` in the freetype gni file
	# drop the last line, then append the freetype line and a new curly brace to end the block
	local freetype_gni="build/config/freetype/freetype.gni"
	sed -i -e '$d' ${freetype_gni} || die
	echo "  enable_freetype = true" >> ${freetype_gni} || die
	echo "}" >> ${freetype_gni} || die

	# See dependency logic in third_party/BUILD.gn
	myconf_gn+=" use_system_harfbuzz=$(usex system-harfbuzz true false)"

	# Optional dependencies.
	myconf_gn+=" enable_hangout_services_extension=$(usex hangouts true false)"
	myconf_gn+=" enable_widevine=$(usex widevine true false)"

	if use headless; then
		myconf_gn+=" use_cups=false"
		myconf_gn+=" use_kerberos=false"
		myconf_gn+=" use_pulseaudio=false"
		myconf_gn+=" use_vaapi=false"
		myconf_gn+=" rtc_use_pipewire=false"
	else
		myconf_gn+=" use_cups=$(usex cups true false)"
		myconf_gn+=" use_kerberos=$(usex kerberos true false)"
		myconf_gn+=" use_pulseaudio=$(usex pulseaudio true false)"
		myconf_gn+=" use_vaapi=$(usex vaapi true false)"
		myconf_gn+=" rtc_use_pipewire=$(usex screencast true false)"
		myconf_gn+=" gtk_version=$(usex gtk4 4 3)"
	fi

	# Allows distributions to link pulseaudio directly (DT_NEEDED) instead of
	# using dlopen. This helps with automated detection of ABI mismatches and
	# prevents silent errors.
	if use pulseaudio; then
		myconf_gn+=" link_pulseaudio=true"
	fi

	# Non-developer builds of Chromium (for example, non-Chrome browsers, or
	# Chromium builds provided by Linux distros) should disable the testing config
	myconf_gn+=" disable_fieldtrial_testing_config=true"

	# The sysroot is the oldest debian image that chromium supports, we don't need it
	myconf_gn+=" use_sysroot=false"

	# Use in-tree libc++ (buildtools/third_party/libc++ and buildtools/third_party/libc++abi)
	# instead of the system C++ library for C++ standard library support.
	# default: true, but let's be explicit (forced since 120 ; USE removed 127).
	myconf_gn+=" use_custom_libcxx=true"

	# Disable pseudolocales, only used for testing
	myconf_gn+=" enable_pseudolocales=false"

	# Disable code formating of generated files
	myconf_gn+=" blink_enable_generated_code_formatting=false"

	if use bindist ; then
		# proprietary_codecs just forces Chromium to say that it can use h264/aac,
		# the work is still done by ffmpeg. If this is set to no Chromium
		# won't be able to load the codec even if the library can handle it
		myconf_gn+=" proprietary_codecs=true"
		myconf_gn+=" ffmpeg_branding=\"Chrome\""
		# build ffmpeg as an external component (libffmpeg.so) that we can remove / substitute
		myconf_gn+=" is_component_ffmpeg=true"
	else
		ffmpeg_branding="$(usex proprietary-codecs Chrome Chromium)"
		myconf_gn+=" proprietary_codecs=$(usex proprietary-codecs true false)"
		myconf_gn+=" ffmpeg_branding=\"${ffmpeg_branding}\""
	fi

	# Set up Google API keys, see http://www.chromium.org/developers/how-tos/api-keys .
	# Note: these are for Gentoo use ONLY. For your own distribution,
	# please get your own set of keys. Feel free to contact chromium@gentoo.org
	# for more info. The OAuth2 credentials, however, have been left out.
	# Those OAuth2 credentials have been broken for quite some time anyway.
	# Instead we apply a patch to use the --oauth2-client-id= and
	# --oauth2-client-secret= switches for setting GOOGLE_DEFAULT_CLIENT_ID and
	# GOOGLE_DEFAULT_CLIENT_SECRET at runtime. This allows signing into
	# Chromium without baked-in values.
	local google_api_key="AIzaSyDEAOvatFo0eTgsV_ZlEzx0ObmepsMzfAc"
	myconf_gn+=" google_api_key=\"${google_api_key}\""
	local myarch="$(tc-arch)"

	# Avoid CFLAGS problems, bug #352457, bug #390147.
	if ! use custom-cflags; then
		replace-flags "-Os" "-O2"
		strip-flags

		# Debug info section overflows without component build
		# Prevent linker from running out of address space, bug #471810 .
		filter-flags "-g*"

		# Prevent libvpx/xnnpack build failures. Bug 530248, 544702, 546984, 853646.
		if [[ ${myarch} == amd64 ]]; then
			filter-flags -mno-mmx -mno-sse2 -mno-ssse3 -mno-sse4.1 -mno-avx -mno-avx2 -mno-fma -mno-fma4 -mno-xop -mno-sse4a
		fi
	fi

	if [[ $myarch = amd64 ]] ; then
		myconf_gn+=" target_cpu=\"x64\""
		ffmpeg_target_arch=x64
	elif [[ $myarch = arm64 ]] ; then
		myconf_gn+=" target_cpu=\"arm64\""
		ffmpeg_target_arch=arm64
	elif [[ $myarch = ppc64 ]] ; then
		myconf_gn+=" target_cpu=\"ppc64\""
		ffmpeg_target_arch=ppc64
	else
		die "Failed to determine target arch, got '$myarch'."
	fi

	myconf_gn+=" treat_warnings_as_errors=false"
	# Disable fatal linker warnings, bug 506268.
	myconf_gn+=" fatal_linker_warnings=false"

	# Disable external code space for V8 for ppc64. It is disabled for ppc64
	# by default, but cross-compiling on amd64 enables it again.
	if tc-is-cross-compiler; then
		if ! use amd64 && ! use arm64; then
			myconf_gn+=" v8_enable_external_code_space=false"
		fi
	fi

	# Only enabled for clang, but gcc has endian macros too
	myconf_gn+=" v8_use_libm_trig_functions=true"

	# Bug 491582.
	export TMPDIR="${WORKDIR}/temp"
	mkdir -p -m 755 "${TMPDIR}" || die

	# https://bugs.gentoo.org/654216
	addpredict /dev/dri/ #nowarn

	# We don't use the same clang version as upstream, and with -Werror
	# we need to make sure that we don't get superfluous warnings.
	append-flags -Wno-unknown-warning-option
	if tc-is-cross-compiler; then
			export BUILD_CXXFLAGS+=" -Wno-unknown-warning-option"
			export BUILD_CFLAGS+=" -Wno-unknown-warning-option"
	fi

	# Explicitly disable ICU data file support for system-icu/headless builds.
	if use system-icu || use headless; then
		myconf_gn+=" icu_use_data_file=false"
	fi

	# Don't need nocompile checks and GN crashes with our config
	myconf_gn+=" enable_nocompile_tests=false"

	# 131 began laying the groundwork for replacing freetype with
	# "Rust-based Fontations set of libraries plus Skia path rendering"
	# We now need to opt-in
	myconf_gn+=" enable_freetype=true"

	# Enable ozone wayland and/or headless support
	myconf_gn+=" use_ozone=true ozone_auto_platforms=false"
	myconf_gn+=" ozone_platform_headless=true"
	if use headless; then
		myconf_gn+=" ozone_platform=\"headless\""
		myconf_gn+=" use_xkbcommon=false use_gtk=false use_qt=false"
		myconf_gn+=" use_glib=false use_gio=false"
		myconf_gn+=" use_pangocairo=false use_alsa=false"
		myconf_gn+=" use_libpci=false use_udev=false"
		myconf_gn+=" enable_print_preview=false"
		myconf_gn+=" enable_remoting=false"
	else
		myconf_gn+=" use_system_libdrm=true"
		myconf_gn+=" use_system_minigbm=true"
		myconf_gn+=" use_xkbcommon=true"
		if use qt5 || use qt6; then
			local cbuild_libdir=$(get_libdir)
			if tc-is-cross-compiler; then
				# Hack to workaround get_libdir not being able to handle CBUILD, bug #794181
				local cbuild_libdir=$($(tc-getBUILD_PKG_CONFIG) --keep-system-libs --libs-only-L libxslt)
				cbuild_libdir=${cbuild_libdir:2}
				cbuild_libdir=${cbuild_libdir/% }
			fi
			if use qt5; then
				if tc-is-cross-compiler; then
					myconf_gn+=" moc_qt5_path=\"${EPREFIX}/${cbuild_libdir}/qt5/bin\""
				else
					myconf_gn+=" moc_qt5_path=\"$(qt5_get_bindir)\""
				fi
			fi
			if use qt6; then
				myconf_gn+=" moc_qt6_path=\"${EPREFIX}/usr/${cbuild_libdir}/qt6/libexec\""
			fi

			myconf_gn+=" use_qt=true"
			myconf_gn+=" use_qt6=$(usex qt6 true false)"
		else
			myconf_gn+=" use_qt=false"
		fi
		myconf_gn+=" ozone_platform_x11=$(usex X true false)"
		myconf_gn+=" ozone_platform_wayland=$(usex wayland true false)"
		myconf_gn+=" ozone_platform=$(usex wayland \"wayland\" \"x11\")"
		use wayland && myconf_gn+=" use_system_libffi=true"
	fi

	myconf_gn+=" use_thin_lto=${use_lto}"
	myconf_gn+=" thin_lto_enable_optimizations=${use_lto}"

	# Enable official builds
	myconf_gn+=" is_official_build=$(usex official true false)"
	if use official; then
		# Allow building against system libraries in official builds
		sed -i 's/OFFICIAL_BUILD/GOOGLE_CHROME_BUILD/' \
			tools/generate_shim_headers/generate_shim_headers.py || die
		myconf_gn+=" is_cfi=${use_lto}"
		# Don't add symbols to build
		myconf_gn+=" symbol_level=0"
	fi

	if use pgo; then
		myconf_gn+=" chrome_pgo_phase=${1}"
		if [[ "$1" == "2" ]]; then
			myconf_gn+=" pgo_data_path=\"${2}\""
		fi
	else
		# Disable PGO
		myconf_gn+=" chrome_pgo_phase=0"
	fi

	# skipping typecheck is only supported on amd64, bug #876157
	if ! use amd64; then
		myconf_gn+=" devtools_skip_typecheck=false"
	fi

	einfo "Configuring Chromium ..."
	set -- gn gen --args="${myconf_gn} ${EXTRA_GN}" out/Release
	echo "$@"
	"$@" || die
}

src_configure() {
	chromium_configure $(usex pgo 1 0)
}

chromium_compile() {

	# Final link uses lots of file descriptors.
	ulimit -n 2048

	# Calling this here supports resumption via FEATURES=keepwork
	python_setup

	# Don't inherit PYTHONPATH from environment, bug #789021, #812689
	local -x PYTHONPATH=

	# Build mksnapshot and pax-mark it.
	if use pax-kernel; then
		local x
		for x in mksnapshot v8_context_snapshot_generator; do
			if tc-is-cross-compiler; then
				eninja -C out/Release "host/${x}"
				pax-mark m "out/Release/host/${x}"
			else
				eninja -C out/Release "${x}"
				pax-mark m "out/Release/${x}"
			fi
		done
	fi

	# Even though ninja autodetects number of CPUs, we respect
	# user's options, for debugging with -j 1 or any other reason.
	eninja -C out/Release chrome chromedriver chrome_sandbox $(use test && echo "base_unittests")

	pax-mark m out/Release/chrome

}

# This function is called from virtx, and must always return so that Xvfb
# session isn't left running. If we return 1, virtx will call die().
chromium_profile() {
	einfo "Profiling for PGO"

	pushd "${WORKDIR}/chromium-profiler-"* >/dev/null || return 1

	# Remove old profdata in case profiling was interrupted.
	rm -rf "${1}" || return 1

	if ! "${EPYTHON}" ./chromium_profiler.py \
		--chrome-executable "${S}/out/Release/chrome" \
		--chromedriver-executable "${S}/out/Release/chromedriver.unstripped" \
		--add-arg no-sandbox --add-arg disable-dev-shm-usage \
		--profile-output "${1}"; then
		eerror "Profiling failed"
		return 1
	fi

	popd >/dev/null || return 1
}

src_compile() {
	if use pgo; then
		local profdata

		profdata="${WORKDIR}/chromium.profdata"

		if [[ ! -e "${WORKDIR}/.pgo-profiled" ]]; then
			chromium_compile
			virtx chromium_profile "$profdata"

			touch "${WORKDIR}/.pgo-profiled" || die
		fi

		if [[ ! -e "${WORKDIR}/.pgo-phase-2-configured" ]]; then
			# Remove phase 1 output
			rm -r out/Release || die

			chromium_configure 2 "$profdata"

			touch "${WORKDIR}/.pgo-phase-2-configured" || die
		fi

		if [[ ! -e "${WORKDIR}/.pgo-phase-2-compiled" ]]; then
			chromium_compile
			touch "${WORKDIR}/.pgo-phase-2-compiled" || die
		fi
	else
		chromium_compile
	fi

	mv out/Release/chromedriver{.unstripped,} || die

	rm -f out/Release/locales/*.pak.info || die

	# Build manpage; bug #684550
	sed -e 's|@@PACKAGE@@|chromium-browser|g;
		s|@@MENUNAME@@|Chromium|g;' \
		chrome/app/resources/manpage.1.in > \
		out/Release/chromium-browser.1 || die

	# Build desktop file; bug #706786
	sed -e 's|@@MENUNAME@@|Chromium|g;
		s|@@USR_BIN_SYMLINK_NAME@@|chromium-browser|g;
		s|@@PACKAGE@@|chromium-browser|g;
		s|\(^Exec=\)/usr/bin/|\1|g;' \
		chrome/installer/linux/common/desktop.template > \
		out/Release/chromium-browser-chromium.desktop || die

	# Build vk_swiftshader_icd.json; bug #827861
	sed -e 's|${ICD_LIBRARY_PATH}|./libvk_swiftshader.so|g' \
		third_party/swiftshader/src/Vulkan/vk_swiftshader_icd.json.tmpl > \
		out/Release/vk_swiftshader_icd.json || die
}

src_test() {
	# Initial list of tests to skip pulled from Alpine. Thanks Lauren!
	# https://issues.chromium.org/issues/40939315
	local skip_tests=(
		'MessagePumpLibeventTest.NestedNotification*'
		ClampTest.Death
		OptionalTest.DereferencingNoValueCrashes
		PlatformThreadTest.SetCurrentThreadTypeTest
		RawPtrTest.TrivialRelocability
		SafeNumerics.IntMaxOperations
		StackTraceTest.TraceStackFramePointersFromBuffer
		StringPieceTest.InvalidLengthDeath
		StringPieceTest.OutOfBoundsDeath
		ThreadPoolEnvironmentConfig.CanUseBackgroundPriorityForWorker
		ValuesUtilTest.FilePath
		# Gentoo-specific
		AlternateTestParams/PartitionAllocDeathTest.RepeatedAllocReturnNullDirect/0
		AlternateTestParams/PartitionAllocDeathTest.RepeatedAllocReturnNullDirect/1
		AlternateTestParams/PartitionAllocDeathTest.RepeatedAllocReturnNullDirect/2
		AlternateTestParams/PartitionAllocDeathTest.RepeatedAllocReturnNullDirect/3
		AlternateTestParams/PartitionAllocDeathTest.RepeatedReallocReturnNullDirect/0
		AlternateTestParams/PartitionAllocDeathTest.RepeatedReallocReturnNullDirect/1
		AlternateTestParams/PartitionAllocDeathTest.RepeatedReallocReturnNullDirect/2
		AlternateTestParams/PartitionAllocDeathTest.RepeatedReallocReturnNullDirect/3
		CharacterEncodingTest.GetCanonicalEncodingNameByAliasName
		CheckExitCodeAfterSignalHandlerDeathTest.CheckSIGFPE
		CheckExitCodeAfterSignalHandlerDeathTest.CheckSIGILL
		CheckExitCodeAfterSignalHandlerDeathTest.CheckSIGSEGV
		CheckExitCodeAfterSignalHandlerDeathTest.CheckSIGSEGVNonCanonicalAddress
		FilePathTest.FromUTF8Unsafe_And_AsUTF8Unsafe
		FileTest.GetInfoForCreationTime
		ICUStringConversionsTest.ConvertToUtf8AndNormalize
		NumberFormattingTest.FormatPercent
		PathServiceTest.CheckedGetFailure
		PlatformThreadTest.CanChangeThreadType
		StackCanary.ChangingStackCanaryCrashesOnReturn
		StackTraceDeathTest.StackDumpSignalHandlerIsMallocFree
		SysStrings.SysNativeMBAndWide
		SysStrings.SysNativeMBToWide
		SysStrings.SysWideToNativeMB
		TestLauncherTools.TruncateSnippetFocusedMatchesFatalMessagesTest
		ToolsSanityTest.BadVirtualCallNull
		ToolsSanityTest.BadVirtualCallWrongType
	)
	local test_filter="-$(IFS=:; printf '%s' "${skip_tests[*]}")"
	# test-launcher-bot-mode enables parallelism and plain output
	./out/Release/base_unittests --test-launcher-bot-mode \
		--test-launcher-jobs="$(makeopts_jobs)" \
		--gtest_filter="${test_filter}" || die "Tests failed!"
}

src_install() {
	local CHROMIUM_HOME="/usr/$(get_libdir)/chromium-browser"
	exeinto "${CHROMIUM_HOME}"
	doexe out/Release/chrome

	newexe out/Release/chrome_sandbox chrome-sandbox
	fperms 4755 "${CHROMIUM_HOME}/chrome-sandbox"

	doexe out/Release/chromedriver
	doexe out/Release/chrome_crashpad_handler

	ozone_auto_session () {
		use X && use wayland && ! use headless && echo true || echo false
	}
	local sedargs=( -e
			"s:/usr/lib/:/usr/$(get_libdir)/:g;
			s:@@OZONE_AUTO_SESSION@@:$(ozone_auto_session):g"
	)
	sed "${sedargs[@]}" "${FILESDIR}/chromium-launcher-r7.sh" > chromium-launcher.sh || die
	doexe chromium-launcher.sh

	# It is important that we name the target "chromium-browser",
	# xdg-utils expect it; bug #355517.
	dosym "${CHROMIUM_HOME}/chromium-launcher.sh" /usr/bin/chromium-browser
	# keep the old symlink around for consistency
	dosym "${CHROMIUM_HOME}/chromium-launcher.sh" /usr/bin/chromium

	dosym "${CHROMIUM_HOME}/chromedriver" /usr/bin/chromedriver

	# Allow users to override command-line options, bug #357629.
	insinto /etc/chromium
	newins "${FILESDIR}/chromium.default" "default"

	pushd out/Release/locales > /dev/null || die
	chromium_remove_language_paks
	popd

	insinto "${CHROMIUM_HOME}"
	doins out/Release/*.bin
	doins out/Release/*.pak

	if use bindist; then
		# We built libffmpeg as a component library, but we can't distribute it
		# with proprietary codec support. Remove it and make a symlink to the requested
		# system library.
		rm -f out/Release/libffmpeg.so \
			|| die "Failed to remove bundled libffmpeg.so (with proprietary codecs)"
		# symlink the libffmpeg.so from either ffmpeg-chromium or ffmpeg[chromium].
		einfo "Creating symlink to libffmpeg.so from $(usex ffmpeg-chromium ffmpeg-chromium ffmpeg[chromium])..."
		dosym ../chromium/libffmpeg.so$(usex ffmpeg-chromium .${PV%%\.*} "") \
			/usr/$(get_libdir)/chromium-browser/libffmpeg.so
	fi

	(
		shopt -s nullglob
		local files=(out/Release/*.so out/Release/*.so.[0-9])
		[[ ${#files[@]} -gt 0 ]] && doins "${files[@]}"
	)

	# Install bundled xdg-utils, avoids installing X11 libraries with USE="-X wayland"
	doins out/Release/xdg-{settings,mime}

	if ! use system-icu && ! use headless; then
		doins out/Release/icudtl.dat
	fi

	doins -r out/Release/locales
	doins -r out/Release/MEIPreload

	# Install vk_swiftshader_icd.json; bug #827861
	doins out/Release/vk_swiftshader_icd.json

	if [[ -d out/Release/swiftshader ]]; then
		insinto "${CHROMIUM_HOME}/swiftshader"
		doins out/Release/swiftshader/*.so
	fi

	# Install icons
	local branding size
	for size in 16 24 32 48 64 128 256 ; do
		case ${size} in
			16|32) branding="chrome/app/theme/default_100_percent/chromium" ;;
				*) branding="chrome/app/theme/chromium" ;;
		esac
		newicon -s ${size} "${branding}/product_logo_${size}.png" \
			chromium-browser.png
	done

	# Install desktop entry
	domenu out/Release/chromium-browser-chromium.desktop

	# Install GNOME default application entry (bug #303100).
	insinto /usr/share/gnome-control-center/default-apps
	newins "${FILESDIR}"/chromium-browser.xml chromium-browser.xml

	# Install manpage; bug #684550
	doman out/Release/chromium-browser.1
	dosym chromium-browser.1 /usr/share/man/man1/chromium.1

	readme.gentoo_create_doc
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	readme.gentoo_print_elog

	if ! use headless; then
		if use vaapi; then
			elog "VA-API is disabled by default at runtime. You have to enable it"
			elog "by adding --enable-features=VaapiVideoDecoder to CHROMIUM_FLAGS"
			elog "in /etc/chromium/default."
		fi
		if use screencast; then
			elog "Screencast is disabled by default at runtime. Either enable it"
			elog "by navigating to chrome://flags/#enable-webrtc-pipewire-capturer"
			elog "inside Chromium or add --enable-features=WebRTCPipeWireCapturer"
			elog "to CHROMIUM_FLAGS in /etc/chromium/default."
		fi
		if use gtk4; then
			elog "Chromium prefers GTK3 over GTK4 at runtime. To override this"
			elog "behavior you need to pass --gtk-version=4, e.g. by adding it"
			elog "to CHROMIUM_FLAGS in /etc/chromium/default."
		fi
		if use qt5 && use qt6; then
			elog "Chromium automatically selects Qt5 or Qt6 based on your desktop"
			elog "environment. To override you need to pass --qt-version=5 or"
			elog "--qt-version=6, e.g. by adding it to CHROMIUM_FLAGS in"
			elog "/etc/chromium/default."
		fi
	fi

	if systemd_is_booted && ! [[ -f "/etc/machine-id" ]]; then
		ewarn "The lack of an '/etc/machine-id' file on this system booted with systemd"
		ewarn "indicates that the Gentoo handbook was not followed to completion."
		ewarn ""
		ewarn "Chromium is known to behave unpredictably with this system configuration;"
		ewarn "please complete the configuration of this system before logging any bugs."
	fi
}
