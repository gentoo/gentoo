# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
PYTHON_COMPAT=( python2_7 )

CHROMIUM_LANGS="am ar bg bn ca cs da de el en-GB es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk vi zh-CN zh-TW"

inherit check-reqs chromium-2 eutils gnome2-utils flag-o-matic multilib multiprocessing pax-utils portability python-any-r1 readme.gentoo-r1 toolchain-funcs versionator virtualx xdg-utils

DESCRIPTION="Open-source version of Google Chrome web browser"
HOMEPAGE="http://chromium.org/"
SRC_URI="https://commondatastorage.googleapis.com/chromium-browser-official/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="cups +gn gnome gnome-keyring gtk3 +hangouts kerberos neon pic +proprietary-codecs pulseaudio selinux +suid +system-ffmpeg +tcmalloc widevine"
RESTRICT="!system-ffmpeg? ( proprietary-codecs? ( bindist ) )"

REQUIRED_USE="gn? ( gnome gnome-keyring )"

# Native Client binaries are compiled with different set of flags, bug #452066.
QA_FLAGS_IGNORED=".*\.nexe"

# Native Client binaries may be stripped by the build system, which uses the
# right tools for it, bug #469144 .
QA_PRESTRIPPED=".*\.nexe"

COMMON_DEPEND="
	app-arch/bzip2:=
	cups? ( >=net-print/cups-1.3.11:= )
	>=dev-libs/elfutils-0.149
	dev-libs/expat:=
	dev-libs/glib:=
	>=dev-libs/jsoncpp-0.5.0-r1:=
	dev-libs/nspr:=
	>=dev-libs/nss-3.14.3:=
	>=dev-libs/re2-0.2016.05.01:=
	gnome? ( >=gnome-base/gconf-2.24.0:= )
	gnome-keyring? ( >=gnome-base/libgnome-keyring-3.12:= )
	>=media-libs/alsa-lib-1.0.19:=
	media-libs/fontconfig:=
	media-libs/freetype:=
	media-libs/libexif:=
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/libvpx:=[svc]
	media-libs/speex:=
	pulseaudio? ( media-sound/pulseaudio:= )
	system-ffmpeg? ( >=media-video/ffmpeg-2.7.2:= )
	sys-apps/dbus:=
	sys-apps/pciutils:=
	>=sys-libs/libcap-2.22:=
	virtual/udev
	x11-libs/cairo:=
	x11-libs/gdk-pixbuf:=
	gtk3? ( x11-libs/gtk+:3= )
	!gtk3? ( x11-libs/gtk+:2= )
	x11-libs/libdrm
	x11-libs/libX11:=
	x11-libs/libXcomposite:=
	x11-libs/libXcursor:=
	x11-libs/libXdamage:=
	x11-libs/libXext:=
	x11-libs/libXfixes:=
	>=x11-libs/libXi-1.6.0:=
	x11-libs/libXinerama:=
	x11-libs/libXrandr:=
	x11-libs/libXrender:=
	x11-libs/libXScrnSaver:=
	x11-libs/libXtst:=
	x11-libs/pango:=
	app-arch/snappy:=
	>=dev-libs/libevent-1.4.13:=
	dev-libs/libxml2:=[icu]
	dev-libs/libxslt:=
	media-libs/flac:=
	>=media-libs/harfbuzz-0.9.41:=[icu(+)]
	>=media-libs/libwebp-0.4.0:=
	sys-libs/zlib:=[minizip]
	kerberos? ( virtual/krb5 )
	!gn? (
		>=app-accessibility/speech-dispatcher-0.8:=
	)
"
# For nvidia-drivers blocker, see bug #413637 .
RDEPEND="${COMMON_DEPEND}
	!=www-client/chromium-9999
	!<www-plugins/chrome-binary-plugins-37
	x11-misc/xdg-utils
	virtual/opengl
	virtual/ttf-fonts
	selinux? ( sec-policy/selinux-chromium )
	tcmalloc? ( !<x11-drivers/nvidia-drivers-331.20 )
	widevine? ( www-plugins/chrome-binary-plugins[widevine(-)] )
"
DEPEND="${COMMON_DEPEND}
	>=app-arch/gzip-1.7
	!arm? (
		dev-lang/yasm
	)
	dev-lang/perl
	dev-perl/JSON
	>=dev-util/gperf-3.0.3
	dev-util/ninja
	sys-apps/hwids[usb(+)]
	>=sys-devel/bison-2.4.3
	sys-devel/flex
	virtual/pkgconfig
	$(python_gen_any_dep '
		dev-python/beautifulsoup:python-2[${PYTHON_USEDEP}]
		>=dev-python/beautifulsoup-4.3.2:4[${PYTHON_USEDEP}]
		dev-python/html5lib[${PYTHON_USEDEP}]
		dev-python/jinja[${PYTHON_USEDEP}]
		dev-python/ply[${PYTHON_USEDEP}]
		dev-python/simplejson[${PYTHON_USEDEP}]
	')
"

# Keep this in sync with the python_gen_any_dep call.
python_check_deps() {
	has_version --host-root "dev-python/beautifulsoup:python-2[${PYTHON_USEDEP}]" &&
	has_version --host-root ">=dev-python/beautifulsoup-4.3.2:4[${PYTHON_USEDEP}]" &&
	has_version --host-root "dev-python/html5lib[${PYTHON_USEDEP}]" &&
	has_version --host-root "dev-python/jinja[${PYTHON_USEDEP}]" &&
	has_version --host-root "dev-python/ply[${PYTHON_USEDEP}]" &&
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

Depending on your desktop environment, you may need
to install additional packages to get icons on the Downloads page.

For KDE, the required package is kde-frameworks/oxygen-icons.

For other desktop environments, try one of the following:
- x11-themes/gnome-icon-theme
- x11-themes/tango-icon-theme
"

PATCHES=(
	"${FILESDIR}/${PN}-system-ffmpeg-r3.patch"
	"${FILESDIR}/${PN}-system-jinja-r13.patch"
	"${FILESDIR}/${PN}-widevine-r1.patch"
	"${FILESDIR}/chromium-54-ffmpeg2compat.patch"
)

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if tc-is-gcc && ! version_is_at_least 4.8 "$(gcc-version)"; then
			die 'At least gcc 4.8 is required, see bugs: #535730, #525374, #518668.'
		fi
	fi

	# Check build requirements, bug #541816 and bug #471810 .
	CHECKREQS_MEMORY="3G"
	CHECKREQS_DISK_BUILD="5G"
	eshopts_push -s extglob
	if is-flagq '-g?(gdb)?([1-9])'; then
		CHECKREQS_DISK_BUILD="25G"
	fi
	eshopts_pop
	check-reqs_pkg_pretend
}

pkg_setup() {
	# Make sure the build system will use the right python, bug #344367.
	python-any-r1_pkg_setup

	chromium_suid_sandbox_check_kernel_config
}

src_prepare() {
	default

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
		breakpad/src/third_party/curl
		chrome/third_party/mozilla_security_manager
		courgette/third_party
		net/third_party/mozilla_security_manager
		net/third_party/nss
		third_party/WebKit
		third_party/analytics
		third_party/angle
		third_party/angle/src/common/third_party/numerics
		third_party/angle/src/third_party/compiler
		third_party/angle/src/third_party/libXNVCtrl
		third_party/angle/src/third_party/murmurhash
		third_party/angle/src/third_party/trace_event
		third_party/boringssl
		third_party/brotli
		third_party/cacheinvalidation
		third_party/catapult
		third_party/catapult/third_party/polymer
		third_party/catapult/third_party/py_vulcanize
		third_party/catapult/third_party/py_vulcanize/third_party/rcssmin
		third_party/catapult/third_party/py_vulcanize/third_party/rjsmin
		third_party/catapult/tracing/third_party/d3
		third_party/catapult/tracing/third_party/gl-matrix
		third_party/catapult/tracing/third_party/jszip
		third_party/catapult/tracing/third_party/mannwhitneyu
		third_party/ced
		third_party/cld_2
		third_party/cld_3
		third_party/cros_system_api
		third_party/cython/python_flags.py
		third_party/devscripts
		third_party/dom_distiller_js
		third_party/fips181
		third_party/flatbuffers
		third_party/flot
		third_party/google_input_tools
		third_party/google_input_tools/third_party/closure_library
		third_party/google_input_tools/third_party/closure_library/third_party/closure
		third_party/hunspell
		third_party/iccjpeg
		third_party/icu
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
		third_party/libusb
		third_party/libwebm
		third_party/libxml/chromium
		third_party/libyuv
		third_party/lss
		third_party/lzma_sdk
		third_party/mesa
		third_party/modp_b64
		third_party/mt19937ar
		third_party/openh264
		third_party/openmax_dl
		third_party/opus
		third_party/ots
		third_party/pdfium
		third_party/pdfium/third_party/agg23
		third_party/pdfium/third_party/base
		third_party/pdfium/third_party/bigint
		third_party/pdfium/third_party/freetype
		third_party/pdfium/third_party/lcms2-2.6
		third_party/pdfium/third_party/libjpeg
		third_party/pdfium/third_party/libopenjpeg20
		third_party/pdfium/third_party/libpng16
		third_party/pdfium/third_party/libtiff
		third_party/pdfium/third_party/zlib_v128
		third_party/polymer
		third_party/protobuf
		third_party/protobuf/third_party/six
		third_party/qcms
		third_party/sfntly
		third_party/skia
		third_party/smhasher
		third_party/sqlite
		third_party/tcmalloc
		third_party/usrsctp
		third_party/web-animations-js
		third_party/webdriver
		third_party/webrtc
		third_party/widevine
		third_party/woff2
		third_party/x86inc
		third_party/zlib/google
		url/third_party/mozilla
		v8/src/third_party/valgrind
	)
	if ! use system-ffmpeg; then
		keeplibs+=( third_party/ffmpeg )
	fi
	if use gn; then
		keeplibs+=(
			base/third_party/libevent
			third_party/adobe
			third_party/speech-dispatcher
			third_party/usb_ids
			third_party/xdg-utils
			third_party/yasm/run_yasm.py
		)
	fi

	# Remove most bundled libraries. Some are still needed.
	build/linux/unbundle/remove_bundled_libraries.py "${keeplibs[@]}" --do-remove || die
}

src_configure() {
	local myconf_gyp=""
	local myconf_gn=""

	# GN needs explicit config for Debug/Release as opposed to inferring it from build directory.
	myconf_gn+=" is_debug=false"

	# Never tell the build system to "enable" SSE2, it has a few unexpected
	# additions, bug #336871.
	myconf_gyp+=" -Ddisable_sse2=1"

	# Disable nacl, we can't build without pnacl (http://crbug.com/269560).
	myconf_gyp+=" -Ddisable_nacl=1"
	myconf_gn+=" enable_nacl=false"

	# Make it possible to remove third_party/adobe.
	echo > "${T}/flapper_version.h" || die
	myconf_gyp+=" -Dflapper_version_h_file=${T}/flapper_version.h"

	# Use system-provided libraries.
	# TODO: use_system_hunspell (upstream changes needed).
	# TODO: use_system_icu (bug #576370).
	# TODO: use_system_libsrtp (bug #459932).
	# TODO: use_system_libusb (http://crbug.com/266149).
	# TODO: use_system_opus (https://code.google.com/p/webrtc/issues/detail?id=3077).
	# TODO: use_system_protobuf (bug #525560).
	# TODO: use_system_ssl (http://crbug.com/58087).
	# TODO: use_system_sqlite (http://crbug.com/22208).
	myconf_gyp+="
		-Duse_system_bzip2=1
		-Duse_system_ffmpeg=$(usex system-ffmpeg 1 0)
		-Duse_system_flac=1
		-Duse_system_harfbuzz=1
		-Duse_system_jsoncpp=1
		-Duse_system_libevent=1
		-Duse_system_libpng=1
		-Duse_system_libvpx=1
		-Duse_system_libwebp=1
		-Duse_system_libxml=1
		-Duse_system_libxslt=1
		-Duse_system_minizip=1
		-Duse_system_nspr=1
		-Duse_system_snappy=1
		-Duse_system_speex=1
		-Duse_system_xdg_utils=1
		-Duse_system_zlib=1"

	local gn_system_libraries="
		flac
		harfbuzz-ng
		libevent
		libjpeg
		libpng
		libvpx
		libwebp
		libxml
		libxslt
		re2
		snappy
		yasm
		zlib"
	if use system-ffmpeg; then
		gn_system_libraries+=" ffmpeg"
	fi
	build/linux/unbundle/replace_gn_files.py --system-libraries ${gn_system_libraries} || die

	# Needed for system icu - we don't need additional data files.
	# myconf_gyp+=" -Dicu_use_data_file_flag=0"

	# TODO: patch gyp so that this arm conditional is not needed.
	if ! use arm; then
		myconf_gyp+="
			-Duse_system_yasm=1"
	fi

	# Optional dependencies.
	# TODO: linux_link_kerberos, bug #381289.
	myconf_gyp+="
		$(gyp_use cups)
		$(gyp_use gnome use_gconf)
		$(gyp_use gnome-keyring use_gnome_keyring)
		$(gyp_use gnome-keyring linux_link_gnome_keyring)
		$(gyp_use gtk3)
		$(gyp_use hangouts enable_hangout_services_extension)
		$(gyp_use kerberos)
		$(gyp_use pulseaudio)
		$(gyp_use tcmalloc use_allocator tcmalloc none)
		$(gyp_use widevine enable_widevine)"

	# TODO: support USE=gnome-keyring for GN
	myconf_gn+=" enable_hangout_services_extension=$(usex hangouts true false)"
	myconf_gn+=" enable_widevine=$(usex widevine true false)"
	myconf_gn+=" use_cups=$(usex cups true false)"
	myconf_gn+=" use_gconf=$(usex gnome true false)"
	myconf_gn+=" use_gtk3=$(usex gtk3 true false)"
	myconf_gn+=" use_kerberos=$(usex kerberos true false)"
	myconf_gn+=" use_pulseaudio=$(usex pulseaudio true false)"

	# Use explicit library dependencies instead of dlopen.
	# This makes breakages easier to detect by revdep-rebuild.
	myconf_gyp+="
		-Dlinux_link_gsettings=1
		-Dlinux_link_libpci=1
		-Dlinux_link_libspeechd=1
		-Dlibspeechd_h_prefix=speech-dispatcher/"

	# TODO: link_pulseaudio=true for GN.

	# TODO: use the file at run time instead of effectively compiling it in.
	myconf_gyp+="
		-Dusb_ids_path=/usr/share/misc/usb.ids"

	myconf_gyp+=" -Dfieldtrial_testing_like_official_build=1"
	myconf_gn+=" fieldtrial_testing_like_official_build=true"

	if tc-is-clang; then
		myconf_gyp+=" -Dclang=1"
		myconf_gn+=" is_clang=true clang_base_path=\"/usr\" clang_use_chrome_plugins=false"
	else
		myconf_gyp+=" -Dclang=0"
		myconf_gn+=" is_clang=false"
	fi

	# Never use bundled gold binary. Disable gold linker flags for now.
	# Do not use bundled clang.
	myconf_gyp+="
		-Dclang_use_chrome_plugins=0
		-Dhost_clang=0
		-Dlinux_use_bundled_binutils=0
		-Dlinux_use_bundled_gold=0
		-Dlinux_use_gold_flags=0
		-Dsysroot="
	# Trying to use gold results in linker crash.
	myconf_gn+=" use_gold=false use_sysroot=false"

	ffmpeg_branding="$(usex proprietary-codecs Chrome Chromium)"
	myconf_gyp+=" -Dproprietary_codecs=1 -Dffmpeg_branding=${ffmpeg_branding}"
	myconf_gn+=" proprietary_codecs=true ffmpeg_branding=\"${ffmpeg_branding}\""

	# Set up Google API keys, see http://www.chromium.org/developers/how-tos/api-keys .
	# Note: these are for Gentoo use ONLY. For your own distribution,
	# please get your own set of keys. Feel free to contact chromium@gentoo.org
	# for more info.
	local google_api_key="AIzaSyDEAOvatFo0eTgsV_ZlEzx0ObmepsMzfAc"
	local google_default_client_id="329227923882.apps.googleusercontent.com"
	local google_default_client_secret="vgKG0NNv7GoDpbtoFNLxCUXu"
	myconf_gyp+=" -Dgoogle_api_key=${google_api_key}
		-Dgoogle_default_client_id=${google_default_client_id}
		-Dgoogle_default_client_secret=${google_default_client_secret}"
	myconf_gn+=" google_api_key=\"${google_api_key}\""
	myconf_gn+=" google_default_client_id=\"${google_default_client_id}\""
	myconf_gn+=" google_default_client_secret=\"${google_default_client_secret}\""

	local myarch="$(tc-arch)"
	if [[ $myarch = amd64 ]] ; then
		target_arch=x64
		ffmpeg_target_arch=x64
	elif [[ $myarch = x86 ]] ; then
		target_arch=ia32
		ffmpeg_target_arch=ia32
	elif [[ $myarch = arm64 ]] ; then
		target_arch=arm64
		ffmpeg_target_arch=arm64
	elif [[ $myarch = arm ]] ; then
		target_arch=arm
		ffmpeg_target_arch=$(usex neon arm-neon arm)
		# TODO: re-enable NaCl (NativeClient).
		local CTARGET=${CTARGET:-${CHOST}}
		if [[ $(tc-is-softfloat) == "no" ]]; then

			myconf_gyp+=" -Darm_float_abi=hard"
		fi
		filter-flags "-mfpu=*"
		use neon || myconf_gyp+=" -Darm_fpu=${ARM_FPU:-vfpv3-d16}"

		if [[ ${CTARGET} == armv[78]* ]]; then
			myconf_gyp+=" -Darmv7=1"
		else
			myconf_gyp+=" -Darmv7=0"
		fi
		myconf_gyp+=" -Dsysroot=
			$(gyp_use neon arm_neon)
			-Ddisable_nacl=1"
	else
		die "Failed to determine target arch, got '$myarch'."
	fi

	myconf_gyp+=" -Dtarget_arch=${target_arch}"

	# Make sure that -Werror doesn't get added to CFLAGS by the build system.
	# Depending on GCC version the warnings are different and we don't want
	# the build to fail because of that.
	myconf_gyp+=" -Dwerror="
	myconf_gn+=" treat_warnings_as_errors=false"

	# Disable fatal linker warnings, bug 506268.
	myconf_gyp+=" -Ddisable_fatal_linker_warnings=1"
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

	# Tools for building programs to be executed on the build system, bug #410883.
	if tc-is-cross-compiler; then
		export AR_host=$(tc-getBUILD_AR)
		export CC_host=$(tc-getBUILD_CC)
		export CXX_host=$(tc-getBUILD_CXX)
		export NM_host=$(tc-getBUILD_NM)
	fi

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
		chromium/scripts/generate_gyp.py || die
		popd > /dev/null || die
	fi

	third_party/libaddressinput/chromium/tools/update-strings.py || die

	touch chrome/test/data/webui/i18n_process_css_test.html || die

	einfo "Configuring Chromium..."
	if use gn; then
		# TODO: bootstrapped gn binary hangs when using tcmalloc with portage's sandbox.
		tools/gn/bootstrap/bootstrap.py -v --gn-gen-args "${myconf_gn} use_allocator=\"none\"" || die
		myconf_gn+=" use_allocator=$(usex tcmalloc \"tcmalloc\" \"none\")"
		out/Release/gn gen --args="${myconf_gn}" out/Release || die
	else
		build/linux/unbundle/replace_gyp_files.py ${myconf_gyp} || die
		egyp_chromium ${myconf_gyp} || die
	fi
}

eninja() {
	if [[ -z ${NINJAOPTS+set} ]]; then
		local jobs=$(makeopts_jobs)
		local loadavg=$(makeopts_loadavg)

		if [[ ${MAKEOPTS} == *-j* && ${jobs} != 999 ]]; then
			NINJAOPTS+=" -j ${jobs}"
		fi
		if [[ ${MAKEOPTS} == *-l* && ${loadavg} != 999 ]]; then
			NINJAOPTS+=" -l ${loadavg}"
		fi
	fi
	set -- ninja -v ${NINJAOPTS} "$@"
	echo "$@"
	"$@"
}

src_compile() {
	local ninja_targets="chrome chromedriver"
	if use suid; then
		ninja_targets+=" chrome_sandbox"
	fi

	# Build mksnapshot and pax-mark it.
	eninja -C out/Release mksnapshot || die
	pax-mark m out/Release/mksnapshot

	# Even though ninja autodetects number of CPUs, we respect
	# user's options, for debugging with -j 1 or any other reason.
	eninja -C out/Release ${ninja_targets} || die

	pax-mark m out/Release/chrome
}

src_install() {
	local CHROMIUM_HOME="/usr/$(get_libdir)/chromium-browser${CHROMIUM_SUFFIX}"
	exeinto "${CHROMIUM_HOME}"
	doexe out/Release/chrome || die

	if use suid; then
		newexe out/Release/chrome_sandbox chrome-sandbox || die
		fperms 4755 "${CHROMIUM_HOME}/chrome-sandbox"
	fi

	doexe out/Release/chromedriver || die
	use widevine && doexe out/Release/libwidevinecdmadapter.so

	# if ! use arm; then
	#	doexe out/Release/nacl_helper{,_bootstrap} || die
	#	insinto "${CHROMIUM_HOME}"
	#	doins out/Release/nacl_irt_*.nexe || die
	#	doins out/Release/libppGoogleNaClPluginChrome.so || die
	# fi

	local sedargs=( -e "s:/usr/lib/:/usr/$(get_libdir)/:g" )
	if [[ -n ${CHROMIUM_SUFFIX} ]]; then
		sedargs+=(
			-e "s:chromium-browser:chromium-browser${CHROMIUM_SUFFIX}:g"
			-e "s:chromium.desktop:chromium${CHROMIUM_SUFFIX}.desktop:g"
			-e "s:plugins:plugins --user-data-dir=\${HOME}/.config/chromium${CHROMIUM_SUFFIX}:"
		)
	fi
	sed "${sedargs[@]}" "${FILESDIR}/chromium-launcher-r3.sh" > chromium-launcher.sh || die
	doexe chromium-launcher.sh

	# It is important that we name the target "chromium-browser",
	# xdg-utils expect it; bug #355517.
	dosym "${CHROMIUM_HOME}/chromium-launcher.sh" /usr/bin/chromium-browser${CHROMIUM_SUFFIX} || die
	# keep the old symlink around for consistency
	dosym "${CHROMIUM_HOME}/chromium-launcher.sh" /usr/bin/chromium${CHROMIUM_SUFFIX} || die

	dosym "${CHROMIUM_HOME}/chromedriver" /usr/bin/chromedriver${CHROMIUM_SUFFIX} || die

	# Allow users to override command-line options, bug #357629.
	dodir /etc/chromium || die
	insinto /etc/chromium
	newins "${FILESDIR}/chromium.default" "default" || die

	pushd out/Release/locales > /dev/null || die
	chromium_remove_language_paks
	popd

	insinto "${CHROMIUM_HOME}"
	doins out/Release/*.bin || die
	doins out/Release/*.pak || die

	doins out/Release/icudtl.dat || die

	doins -r out/Release/locales || die
	doins -r out/Release/resources || die

	newman out/Release/chrome.1 chromium${CHROMIUM_SUFFIX}.1 || die
	newman out/Release/chrome.1 chromium-browser${CHROMIUM_SUFFIX}.1 || die

	# Install icons and desktop entry.
	local branding size
	for size in 16 22 24 32 48 64 128 256 ; do
		case ${size} in
			16|32) branding="chrome/app/theme/default_100_percent/chromium" ;;
				*) branding="chrome/app/theme/chromium" ;;
		esac
		newicon -s ${size} "${branding}/product_logo_${size}.png" \
			chromium-browser${CHROMIUM_SUFFIX}.png
	done

	local mime_types="text/html;text/xml;application/xhtml+xml;"
	mime_types+="x-scheme-handler/http;x-scheme-handler/https;" # bug #360797
	mime_types+="x-scheme-handler/ftp;" # bug #412185
	mime_types+="x-scheme-handler/mailto;x-scheme-handler/webcal;" # bug #416393
	make_desktop_entry \
		chromium-browser${CHROMIUM_SUFFIX} \
		"Chromium${CHROMIUM_SUFFIX}" \
		chromium-browser${CHROMIUM_SUFFIX} \
		"Network;WebBrowser" \
		"MimeType=${mime_types}\nStartupWMClass=chromium-browser"
	sed -e "/^Exec/s/$/ %U/" -i "${ED}"/usr/share/applications/*.desktop || die

	# Install GNOME default application entry (bug #303100).
	if use gnome; then
		dodir /usr/share/gnome-control-center/default-apps || die
		insinto /usr/share/gnome-control-center/default-apps
		newins "${FILESDIR}"/chromium-browser.xml chromium-browser${CHROMIUM_SUFFIX}.xml || die
		if [[ "${CHROMIUM_SUFFIX}" != "" ]]; then
			sed "s:chromium-browser:chromium-browser${CHROMIUM_SUFFIX}:g" -i \
				"${ED}"/usr/share/gnome-control-center/default-apps/chromium-browser${CHROMIUM_SUFFIX}.xml
		fi
	fi

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
