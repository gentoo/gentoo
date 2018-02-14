# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python2_7 )

CHROMIUM_LANGS="am ar bg bn ca cs da de el en-GB es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk vi zh-CN zh-TW"

inherit check-reqs chromium-2 eutils gnome2-utils flag-o-matic multilib ninja-utils pax-utils portability python-any-r1 readme.gentoo-r1 toolchain-funcs versionator xdg-utils

DESCRIPTION="Open-source version of Google Chrome web browser"
HOMEPAGE="http://chromium.org/"
SRC_URI="https://commondatastorage.googleapis.com/chromium-browser-official/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="component-build cups gnome-keyring +hangouts jumbo-build kerberos neon pic +proprietary-codecs pulseaudio selinux +suid +system-ffmpeg +system-icu +system-libvpx +tcmalloc widevine"
RESTRICT="!system-ffmpeg? ( proprietary-codecs? ( bindist ) )"

COMMON_DEPEND="
	app-accessibility/at-spi2-atk:2
	app-arch/bzip2:=
	cups? ( >=net-print/cups-1.3.11:= )
	dev-libs/atk
	dev-libs/expat:=
	dev-libs/glib:2
	system-icu? ( >=dev-libs/icu-59:= )
	>=dev-libs/libxml2-2.9.4-r3:=[icu]
	dev-libs/libxslt:=
	dev-libs/nspr:=
	>=dev-libs/nss-3.26:=
	>=dev-libs/re2-0.2016.05.01:=
	gnome-keyring? ( >=gnome-base/libgnome-keyring-3.12:= )
	>=media-libs/alsa-lib-1.0.19:=
	media-libs/fontconfig:=
	media-libs/freetype:=
	>=media-libs/harfbuzz-1.5.0:=[icu(-)]
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	system-libvpx? ( media-libs/libvpx:=[postproc,svc] )
	>=media-libs/openh264-1.6.0:=
	pulseaudio? ( media-sound/pulseaudio:= )
	system-ffmpeg? (
		>=media-video/ffmpeg-3:=
		|| (
			media-video/ffmpeg[-samba]
			>=net-fs/samba-4.5.10-r1[-debug(-)]
		)
		!=net-fs/samba-4.5.12
		media-libs/opus:=
	)
	sys-apps/dbus:=
	sys-apps/pciutils:=
	virtual/udev
	x11-libs/cairo:=
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3[X]
	x11-libs/libX11:=
	x11-libs/libXcomposite:=
	x11-libs/libXcursor:=
	x11-libs/libXdamage:=
	x11-libs/libXext:=
	x11-libs/libXfixes:=
	>=x11-libs/libXi-1.6.0:=
	x11-libs/libXrandr:=
	x11-libs/libXrender:=
	x11-libs/libXScrnSaver:=
	x11-libs/libXtst:=
	x11-libs/pango:=
	app-arch/snappy:=
	media-libs/flac:=
	>=media-libs/libwebp-0.4.0:=
	sys-libs/zlib:=[minizip]
	kerberos? ( virtual/krb5 )
"
# For nvidia-drivers blocker, see bug #413637 .
RDEPEND="${COMMON_DEPEND}
	!=www-client/chromium-9999
	!<www-plugins/chrome-binary-plugins-57
	x11-misc/xdg-utils
	virtual/opengl
	virtual/ttf-fonts
	selinux? ( sec-policy/selinux-chromium )
	tcmalloc? ( !<x11-drivers/nvidia-drivers-331.20 )
	widevine? ( www-plugins/chrome-binary-plugins[widevine(-)] )
"
# dev-vcs/git - https://bugs.gentoo.org/593476
# sys-apps/sandbox - https://crbug.com/586444
DEPEND="${COMMON_DEPEND}
	>=app-arch/gzip-1.7
	!arm? (
		dev-lang/yasm
	)
	dev-lang/perl
	>=dev-util/gperf-3.0.3
	>=dev-util/ninja-1.7.2
	>=net-libs/nodejs-6.9.4
	sys-apps/hwids[usb(+)]
	>=sys-devel/bison-2.4.3
	sys-devel/flex
	virtual/pkgconfig
	dev-vcs/git
	$(python_gen_any_dep '
		dev-python/beautifulsoup:python-2[${PYTHON_USEDEP}]
		>=dev-python/beautifulsoup-4.3.2:4[${PYTHON_USEDEP}]
		dev-python/html5lib[${PYTHON_USEDEP}]
		dev-python/simplejson[${PYTHON_USEDEP}]
	')
"

# Keep this in sync with the python_gen_any_dep call.
python_check_deps() {
	has_version --host-root "dev-python/beautifulsoup:python-2[${PYTHON_USEDEP}]" &&
	has_version --host-root ">=dev-python/beautifulsoup-4.3.2:4[${PYTHON_USEDEP}]" &&
	has_version --host-root "dev-python/html5lib[${PYTHON_USEDEP}]" &&
	has_version --host-root "dev-python/simplejson[${PYTHON_USEDEP}]"
}

if ! has chromium_pkg_die ${EBUILD_DEATH_HOOKS}; then
	EBUILD_DEATH_HOOKS+=" chromium_pkg_die";
fi

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
Some web pages may require additional fonts to display properly.
Try installing some of the following packages if some characters
are not displayed properly:
- media-fonts/arphicfonts
- media-fonts/bitstream-cyberbit
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
"

PATCHES=(
	"${FILESDIR}/chromium-widevine-r1.patch"
	"${FILESDIR}/chromium-FORTIFY_SOURCE-r2.patch"
	"${FILESDIR}/chromium-webrtc-r0.patch"
	"${FILESDIR}/chromium-memcpy-r0.patch"
	"${FILESDIR}/chromium-cups-r0.patch"
	"${FILESDIR}/chromium-clang-r2.patch"
	"${FILESDIR}/chromium-angle-r0.patch"
	"${FILESDIR}/chromium-ffmpeg-r0.patch"
)

pre_build_checks() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		local -x CPP="$(tc-getCXX) -E"
		if tc-is-clang && ! version_is_at_least "3.9.1" "$(clang-fullversion)"; then
			# bugs: #601654
			die "At least clang 3.9.1 is required"
		fi
		if tc-is-gcc && ! version_is_at_least 5.0 "$(gcc-version)"; then
			# bugs: #535730, #525374, #518668, #600288, #627356
			die "At least gcc 5.0 is required"
		fi
	fi

	# Check build requirements, bug #541816 and bug #471810 .
	CHECKREQS_MEMORY="3G"
	CHECKREQS_DISK_BUILD="5G"
	eshopts_push -s extglob
	if is-flagq '-g?(gdb)?([1-9])'; then
		CHECKREQS_DISK_BUILD="25G"
		if ! use component-build; then
			CHECKREQS_MEMORY="16G"
		fi
	fi
	eshopts_pop
	check-reqs_pkg_setup
}

pkg_pretend() {
	pre_build_checks
}

pkg_setup() {
	pre_build_checks

	chromium_suid_sandbox_check_kernel_config
}

src_prepare() {
	# Calling this here supports resumption via FEATURES=keepwork
	python_setup

	default

	mkdir -p third_party/node/linux/node-linux-x64/bin || die
	ln -s "${EPREFIX}"/usr/bin/node third_party/node/linux/node-linux-x64/bin/node || die

	local keeplibs=(
		base/third_party/dmg_fp
		base/third_party/dynamic_annotations
		base/third_party/icu
		base/third_party/nspr
		base/third_party/superfasthash
		base/third_party/symbolize
		base/third_party/valgrind
		base/third_party/xdg_mime
		base/third_party/xdg_user_dirs
		chrome/third_party/mozilla_security_manager
		courgette/third_party
		net/third_party/mozilla_security_manager
		net/third_party/nss
		third_party/WebKit
		third_party/analytics
		third_party/angle
		third_party/angle/src/common/third_party/base
		third_party/angle/src/common/third_party/smhasher
		third_party/angle/src/third_party/compiler
		third_party/angle/src/third_party/libXNVCtrl
		third_party/angle/src/third_party/trace_event
		third_party/blink
		third_party/boringssl
		third_party/boringssl/src/third_party/fiat
		third_party/breakpad
		third_party/breakpad/breakpad/src/third_party/curl
		third_party/brotli
		third_party/cacheinvalidation
		third_party/catapult
		third_party/catapult/common/py_vulcanize/third_party/rcssmin
		third_party/catapult/common/py_vulcanize/third_party/rjsmin
		third_party/catapult/third_party/polymer
		third_party/catapult/tracing/third_party/d3
		third_party/catapult/tracing/third_party/gl-matrix
		third_party/catapult/tracing/third_party/jszip
		third_party/catapult/tracing/third_party/mannwhitneyu
		third_party/catapult/tracing/third_party/oboe
		third_party/catapult/tracing/third_party/pako
		third_party/ced
		third_party/cld_3
		third_party/crc32c
		third_party/cros_system_api
		third_party/devscripts
		third_party/dom_distiller_js
		third_party/fips181
		third_party/flatbuffers
		third_party/flot
		third_party/freetype
		third_party/glslang-angle
		third_party/google_input_tools
		third_party/google_input_tools/third_party/closure_library
		third_party/google_input_tools/third_party/closure_library/third_party/closure
		third_party/googletest
		third_party/hunspell
		third_party/iccjpeg
		third_party/inspector_protocol
		third_party/jinja2
		third_party/jstemplate
		third_party/khronos
		third_party/leveldatabase
		third_party/libXNVCtrl
		third_party/libaddressinput
		third_party/libjingle
		third_party/libphonenumber
		third_party/libsecret
		third_party/libsrtp
		third_party/libudev
		third_party/libwebm
		third_party/libxml/chromium
		third_party/libyuv
		third_party/lss
		third_party/lzma_sdk
		third_party/markupsafe
		third_party/mesa
		third_party/metrics_proto
		third_party/modp_b64
		third_party/mt19937ar
		third_party/node
		third_party/node/node_modules/polymer-bundler/lib/third_party/UglifyJS2
		third_party/openmax_dl
		third_party/ots
		third_party/pdfium
		third_party/pdfium/third_party/agg23
		third_party/pdfium/third_party/base
		third_party/pdfium/third_party/build
		third_party/pdfium/third_party/bigint
		third_party/pdfium/third_party/freetype
		third_party/pdfium/third_party/lcms
		third_party/pdfium/third_party/libopenjpeg20
		third_party/pdfium/third_party/libpng16
		third_party/pdfium/third_party/libtiff
		third_party/ply
		third_party/polymer
		third_party/protobuf
		third_party/protobuf/third_party/six
		third_party/qcms
		third_party/sfntly
		third_party/skia
		third_party/skia/third_party/gif
		third_party/skia/third_party/vulkan
		third_party/smhasher
		third_party/spirv-headers
		third_party/spirv-tools-angle
		third_party/sqlite
		third_party/swiftshader
		third_party/swiftshader/third_party/llvm-subzero
		third_party/swiftshader/third_party/subzero
		third_party/usrsctp
		third_party/vulkan
		third_party/vulkan-validation-layers
		third_party/web-animations-js
		third_party/webdriver
		third_party/webrtc
		third_party/widevine
		third_party/woff2
		third_party/zlib/google
		url/third_party/mozilla
		v8/src/third_party/valgrind
		v8/third_party/inspector_protocol

		# gyp -> gn leftovers
		base/third_party/libevent
		third_party/adobe
		third_party/speech-dispatcher
		third_party/usb_ids
		third_party/xdg-utils
		third_party/yasm/run_yasm.py
	)
	if ! use system-ffmpeg; then
		keeplibs+=( third_party/ffmpeg third_party/opus )
	fi
	if ! use system-icu; then
		keeplibs+=( third_party/icu )
	fi
	if ! use system-libvpx; then
		keeplibs+=( third_party/libvpx )
		keeplibs+=( third_party/libvpx/source/libvpx/third_party/x86inc )
	fi
	if use tcmalloc; then
		keeplibs+=( third_party/tcmalloc )
	fi

	# Remove most bundled libraries. Some are still needed.
	build/linux/unbundle/remove_bundled_libraries.py "${keeplibs[@]}" --do-remove || die
}

bootstrap_gn() {
	if tc-is-cross-compiler; then
		local -x AR=${BUILD_AR}
		local -x CC=${BUILD_CC}
		local -x CXX=${BUILD_CXX}
		local -x NM=${BUILD_NM}
		local -x CFLAGS=${BUILD_CFLAGS}
		local -x CXXFLAGS=${BUILD_CXXFLAGS}
		local -x LDFLAGS=${BUILD_LDFLAGS}
	fi
	einfo "Building GN..."
	set -- tools/gn/bootstrap/bootstrap.py -s -v --no-clean
	echo "$@"
	"$@" || die
}

src_configure() {
	# Calling this here supports resumption via FEATURES=keepwork
	python_setup

	local myconf_gn=""

	# GN needs explicit config for Debug/Release as opposed to inferring it from build directory.
	myconf_gn+=" is_debug=false"

	# Component build isn't generally intended for use by end users. It's mostly useful
	# for development and debugging.
	myconf_gn+=" is_component_build=$(usex component-build true false)"

	# https://chromium.googlesource.com/chromium/src/+/lkcr/docs/jumbo.md
	myconf_gn+=" use_jumbo_build=$(usex jumbo-build true false)"

	myconf_gn+=" use_allocator=$(usex tcmalloc \"tcmalloc\" \"none\")"

	# Disable nacl, we can't build without pnacl (http://crbug.com/269560).
	myconf_gn+=" enable_nacl=false"

	# Use system-provided libraries.
	# TODO: freetype (https://bugs.chromium.org/p/pdfium/issues/detail?id=733).
	# TODO: use_system_hunspell (upstream changes needed).
	# TODO: use_system_libsrtp (bug #459932).
	# TODO: use_system_protobuf (bug #525560).
	# TODO: use_system_ssl (http://crbug.com/58087).
	# TODO: use_system_sqlite (http://crbug.com/22208).

	# libevent: https://bugs.gentoo.org/593458
	local gn_system_libraries=(
		flac
		# Need harfbuzz_from_pkgconfig target
		#harfbuzz-ng
		libdrm
		libjpeg
		libpng
		libwebp
		libxml
		libxslt
		openh264
		re2
		snappy
		yasm
		zlib
	)
	if use system-ffmpeg; then
		gn_system_libraries+=( ffmpeg opus )
	fi
	if use system-icu; then
		gn_system_libraries+=( icu )
	fi
	if use system-libvpx; then
		gn_system_libraries+=( libvpx )
	fi
	build/linux/unbundle/replace_gn_files.py --system-libraries "${gn_system_libraries[@]}" || die

	# See dependency logic in third_party/BUILD.gn
	myconf_gn+=" use_system_harfbuzz=true"

	# Optional dependencies.
	myconf_gn+=" enable_hangout_services_extension=$(usex hangouts true false)"
	myconf_gn+=" enable_widevine=$(usex widevine true false)"
	myconf_gn+=" use_cups=$(usex cups true false)"
	myconf_gn+=" use_gconf=false"
	myconf_gn+=" use_gnome_keyring=$(usex gnome-keyring true false)"
	myconf_gn+=" use_kerberos=$(usex kerberos true false)"
	myconf_gn+=" use_pulseaudio=$(usex pulseaudio true false)"

	# TODO: link_pulseaudio=true for GN.

	myconf_gn+=" fieldtrial_testing_like_official_build=true"

	if tc-is-clang; then
		myconf_gn+=" is_clang=true clang_use_chrome_plugins=false"
	else
		myconf_gn+=" is_clang=false"
	fi

	# Never use bundled gold binary. Disable gold linker flags for now.
	# Do not use bundled clang.
	# Trying to use gold results in linker crash.
	myconf_gn+=" use_gold=false use_sysroot=false linux_use_bundled_binutils=false use_custom_libcxx=false"

	# Disable forced lld, bug 641556
	myconf_gn+=" use_lld=false"

	ffmpeg_branding="$(usex proprietary-codecs Chrome Chromium)"
	myconf_gn+=" proprietary_codecs=$(usex proprietary-codecs true false)"
	myconf_gn+=" ffmpeg_branding=\"${ffmpeg_branding}\""

	# Set up Google API keys, see http://www.chromium.org/developers/how-tos/api-keys .
	# Note: these are for Gentoo use ONLY. For your own distribution,
	# please get your own set of keys. Feel free to contact chromium@gentoo.org
	# for more info.
	local google_api_key="AIzaSyDEAOvatFo0eTgsV_ZlEzx0ObmepsMzfAc"
	local google_default_client_id="329227923882.apps.googleusercontent.com"
	local google_default_client_secret="vgKG0NNv7GoDpbtoFNLxCUXu"
	myconf_gn+=" google_api_key=\"${google_api_key}\""
	myconf_gn+=" google_default_client_id=\"${google_default_client_id}\""
	myconf_gn+=" google_default_client_secret=\"${google_default_client_secret}\""

	local myarch="$(tc-arch)"
	if [[ $myarch = amd64 ]] ; then
		myconf_gn+=" target_cpu=\"x64\""
		ffmpeg_target_arch=x64
	elif [[ $myarch = x86 ]] ; then
		myconf_gn+=" target_cpu=\"x86\""
		ffmpeg_target_arch=ia32
	elif [[ $myarch = arm64 ]] ; then
		myconf_gn+=" target_cpu=\"arm64\""
		ffmpeg_target_arch=arm64
	elif [[ $myarch = arm ]] ; then
		myconf_gn+=" target_cpu=\"arm\""
		ffmpeg_target_arch=$(usex neon arm-neon arm)
	else
		die "Failed to determine target arch, got '$myarch'."
	fi

	# Make sure that -Werror doesn't get added to CFLAGS by the build system.
	# Depending on GCC version the warnings are different and we don't want
	# the build to fail because of that.
	myconf_gn+=" treat_warnings_as_errors=false"

	# Disable fatal linker warnings, bug 506268.
	myconf_gn+=" fatal_linker_warnings=false"

	# Avoid CFLAGS problems, bug #352457, bug #390147.
	if ! use custom-cflags; then
		replace-flags "-Os" "-O2"
		strip-flags

		# Prevent linker from running out of address space, bug #471810 .
		if use x86; then
			filter-flags "-g*"
		fi

		# Prevent libvpx build failures. Bug 530248, 544702, 546984.
		if [[ ${myarch} == amd64 || ${myarch} == x86 ]]; then
			filter-flags -mno-mmx -mno-sse2 -mno-ssse3 -mno-sse4.1 -mno-avx -mno-avx2
		fi
	fi

	# Make sure the build system will use the right tools, bug #340795.
	tc-export AR CC CXX NM

	# Define a custom toolchain for GN
	myconf_gn+=" custom_toolchain=\"//build/toolchain/linux/unbundle:default\""

	if tc-is-cross-compiler; then
		tc-export BUILD_{AR,CC,CXX,NM}
		myconf_gn+=" host_toolchain=\"//build/toolchain/linux/unbundle:host\""
		myconf_gn+=" v8_snapshot_toolchain=\"//build/toolchain/linux/unbundle:host\""
	else
		myconf_gn+=" host_toolchain=\"//build/toolchain/linux/unbundle:default\""
	fi

	# https://bugs.gentoo.org/588596
	append-cxxflags $(test-flags-CXX -fno-delete-null-pointer-checks)

	# Bug 491582.
	export TMPDIR="${WORKDIR}/temp"
	mkdir -p -m 755 "${TMPDIR}" || die

	if ! use system-ffmpeg; then
		local build_ffmpeg_args=""
		if use pic && [[ "${ffmpeg_target_arch}" == "ia32" ]]; then
			build_ffmpeg_args+=" --disable-asm"
		fi

		# Re-configure bundled ffmpeg. See bug #491378 for example reasons.
		einfo "Configuring bundled ffmpeg..."
		pushd third_party/ffmpeg > /dev/null || die
		chromium/scripts/build_ffmpeg.py linux ${ffmpeg_target_arch} \
			--branding ${ffmpeg_branding} -- ${build_ffmpeg_args} || die
		chromium/scripts/copy_config.sh || die
		chromium/scripts/generate_gn.py || die
		popd > /dev/null || die
	fi

	bootstrap_gn

	einfo "Configuring Chromium..."
	set -- out/Release/gn gen --args="${myconf_gn} ${EXTRA_GN}" out/Release
	echo "$@"
	"$@" || die
}

src_compile() {
	# Calling this here supports resumption via FEATURES=keepwork
	python_setup

	# Build mksnapshot and pax-mark it.
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

	# Work around circular dep issue
	# https://chromium-review.googlesource.com/c/chromium/src/+/617768
	eninja -C out/Release gen/ui/accessibility/ax_enums.h

	# Even though ninja autodetects number of CPUs, we respect
	# user's options, for debugging with -j 1 or any other reason.
	eninja -C out/Release chrome chromedriver
	use suid && eninja -C out/Release chrome_sandbox

	pax-mark m out/Release/chrome
}

src_install() {
	local CHROMIUM_HOME="/usr/$(get_libdir)/chromium-browser"
	exeinto "${CHROMIUM_HOME}"
	doexe out/Release/chrome

	if use suid; then
		newexe out/Release/chrome_sandbox chrome-sandbox
		fperms 4755 "${CHROMIUM_HOME}/chrome-sandbox"
	fi

	doexe out/Release/chromedriver

	local sedargs=( -e "s:/usr/lib/:/usr/$(get_libdir)/:g" )
	sed "${sedargs[@]}" "${FILESDIR}/chromium-launcher-r3.sh" > chromium-launcher.sh || die
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

	if use widevine; then
		# These will be provided by chrome-binary-plugins
		rm out/Release/libwidevinecdm*.so || die
	fi

	insinto "${CHROMIUM_HOME}"
	doins out/Release/*.bin
	doins out/Release/*.pak
	doins out/Release/*.so

	if ! use system-icu; then
		doins out/Release/icudtl.dat
	fi

	doins -r out/Release/locales
	doins -r out/Release/resources

	if [[ -d out/Release/swiftshader ]]; then
		insinto "${CHROMIUM_HOME}/swiftshader"
		doins out/Release/swiftshader/*.so
	fi

	# Install icons and desktop entry.
	local branding size
	for size in 16 22 24 32 48 64 128 256 ; do
		case ${size} in
			16|32) branding="chrome/app/theme/default_100_percent/chromium" ;;
				*) branding="chrome/app/theme/chromium" ;;
		esac
		newicon -s ${size} "${branding}/product_logo_${size}.png" \
			chromium-browser.png
	done

	local mime_types="text/html;text/xml;application/xhtml+xml;"
	mime_types+="x-scheme-handler/http;x-scheme-handler/https;" # bug #360797
	mime_types+="x-scheme-handler/ftp;" # bug #412185
	mime_types+="x-scheme-handler/mailto;x-scheme-handler/webcal;" # bug #416393
	make_desktop_entry \
		chromium-browser \
		"Chromium" \
		chromium-browser \
		"Network;WebBrowser" \
		"MimeType=${mime_types}\nStartupWMClass=chromium-browser"
	sed -e "/^Exec/s/$/ %U/" -i "${ED}"/usr/share/applications/*.desktop || die

	# Install GNOME default application entry (bug #303100).
	insinto /usr/share/gnome-control-center/default-apps
	newins "${FILESDIR}"/chromium-browser.xml chromium-browser.xml

	readme.gentoo_create_doc
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
	readme.gentoo_print_elog
}
