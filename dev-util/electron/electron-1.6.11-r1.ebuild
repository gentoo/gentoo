# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python2_7 )

CHROMIUM_LANGS="am ar bg bn ca cs da de el en-GB es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk vi zh-CN zh-TW"

inherit check-reqs chromium-2 eutils gnome2-utils flag-o-matic multilib \
	multiprocessing pax-utils portability python-any-r1 toolchain-funcs \
	versionator virtualx xdg-utils

# Keep this in sync with vendor/brightray/vendor/libchromiumcontent/VERSION
CHROMIUM_VERSION="56.0.2924.87"
# Keep this in sync with vendor/breakpad
BREAKPAD_COMMIT="c566c50d81f7b1edeaee9f11f5d07bda858d6b64"
# Keep this in sync with vendor/breakpad/src (and find the corresponding
# commit in https://github.com/google/breakpad/)
BREAKPAD_SRC_COMMIT="e35167de7516448fcc2bf687ad580b9d8b6aedc2"
# Keep this in sync with vendor/brightray
BRIGHTRAY_COMMIT="909c49265493bd095c27cefd999567be2107899a"
# Keep this in sync with vendor/node
NODE_COMMIT="9b1683e7000481ec6214eafa3eef7ac4594eb410"
# Keep this in sync with vendor/native_mate
NATIVE_MATE_COMMIT="fd0e7dc4ab778f0d1ccda6c9640464ea06ee771e"
# Keep this in sync with vendor/pdf_viewer
PDF_VIEWER_COMMIT="a050a339cfeabcfb5f07c313161d2ee27b6c3a39"
# Keep this in sync with vendor/pdf_viewer/vendor/grit
GRIT_COMMIT="9536fb6429147d27ef1563088341825db0a893cd"
# Keep this in sync with script/lib/config.py:LIBCHROMIUMCONTENT_COMMIT
LIBCHROMIUMCONTENT_COMMIT="e2ec6935fbf034207d5ad00fa905a4b2cdd60bb7"
# Keep this in sync with package.json#devDependencies
ASAR_VERSION="0.12.1"
BROWSERIFY_VERSION="14.0.0"

CHROMIUM_P="chromium-${CHROMIUM_VERSION}"
BREAKPAD_P="chromium-breakpad-${BREAKPAD_COMMIT}"
BREAKPAD_SRC_P="breakpad-${BREAKPAD_SRC_COMMIT}"
BRIGHTRAY_P="brightray-${BRIGHTRAY_COMMIT}"
NODE_P="node-${NODE_COMMIT}"
NATIVE_MATE_P="native-mate-${NATIVE_MATE_COMMIT}"
PDF_VIEWER_P="pdf-viewer-${PDF_VIEWER_COMMIT}"
GRIT_P="grit-${GRIT_COMMIT}"
LIBCHROMIUMCONTENT_P="libchromiumcontent-${LIBCHROMIUMCONTENT_COMMIT}"
ASAR_P="asar-${ASAR_VERSION}"
BROWSERIFY_P="browserify-${BROWSERIFY_VERSION}"

DESCRIPTION="Cross platform application development framework based on web technologies"
HOMEPAGE="http://electron.atom.io/"
SRC_URI="
	https://commondatastorage.googleapis.com/chromium-browser-official/${CHROMIUM_P}.tar.xz
	https://github.com/electron/electron/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/electron/chromium-breakpad/archive/${BREAKPAD_COMMIT}.tar.gz -> electron-${BREAKPAD_P}.tar.gz
	https://github.com/google/breakpad/archive/${BREAKPAD_SRC_COMMIT}.tar.gz -> electron-${BREAKPAD_SRC_P}.tar.gz
	https://github.com/electron/brightray/archive/${BRIGHTRAY_COMMIT}.tar.gz -> electron-${BRIGHTRAY_P}.tar.gz
	https://github.com/electron/node/archive/${NODE_COMMIT}.tar.gz -> electron-${NODE_P}.tar.gz
	https://github.com/zcbenz/native-mate/archive/${NATIVE_MATE_COMMIT}.tar.gz -> electron-${NATIVE_MATE_P}.tar.gz
	https://github.com/electron/pdf-viewer/archive/${PDF_VIEWER_COMMIT}.tar.gz -> electron-${PDF_VIEWER_P}.tar.gz
	https://github.com/elprans/grit/archive/${GRIT_COMMIT}.tar.gz -> electron-${GRIT_P}.tar.gz
	https://github.com/electron/libchromiumcontent/archive/${LIBCHROMIUMCONTENT_COMMIT}.tar.gz -> electron-${LIBCHROMIUMCONTENT_P}.tar.gz
	https://github.com/elprans/asar/releases/download/v${ASAR_VERSION}-gentoo/asar-build.tar.gz -> ${ASAR_P}.tar.gz
	https://github.com/elprans/node-browserify/releases/download/${BROWSERIFY_VERSION}-gentoo/browserify-build.tar.gz -> ${BROWSERIFY_P}.tar.gz
"

S="${WORKDIR}/${P}"
CHROMIUM_S="${S}/chromium"
NODE_S="${S}/vendor/node"
BREAKPAD_S="${S}/vendor/breakpad"
BREAKPAD_SRC_S="${BREAKPAD_S}/src"
BRIGHTRAY_S="${S}/vendor/brightray"
NATIVE_MATE_S="${S}/vendor/native_mate"
PDF_VIEWER_S="${S}/vendor/pdf_viewer"
GRIT_S="${PDF_VIEWER_S}/vendor/grit"
LIBCC_S="${BRIGHTRAY_S}/vendor/libchromiumcontent"

LICENSE="BSD"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64"
IUSE="cups custom-cflags gnome gnome-keyring kerberos lto neon pic +proprietary-codecs pulseaudio selinux +system-ffmpeg +tcmalloc"
RESTRICT="!system-ffmpeg? ( proprietary-codecs? ( bindist ) )"

# Native Client binaries are compiled with different set of flags, bug #452066.
QA_FLAGS_IGNORED=".*\.nexe"

# Native Client binaries may be stripped by the build system, which uses the
# right tools for it, bug #469144 .
QA_PRESTRIPPED=".*\.nexe"

COMMON_DEPEND="
	app-arch/bzip2:=
	>=app-eselect/eselect-electron-2.0
	cups? ( >=net-print/cups-1.3.11:= )
	>=dev-libs/elfutils-0.149
	dev-libs/expat:=
	dev-libs/glib:2
	dev-libs/icu:=
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
	system-ffmpeg? ( >=media-video/ffmpeg-3:= )
	sys-apps/dbus:=
	sys-apps/pciutils:=
	>=sys-libs/libcap-2.22:=
	virtual/udev
	x11-libs/cairo:=
	x11-libs/gdk-pixbuf:2
	x11-libs/libdrm
	x11-libs/libnotify:=
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
	dev-libs/libxml2:=[icu]
	dev-libs/libxslt:=
	media-libs/flac:=
	>=media-libs/harfbuzz-1.3.1:=[icu(+)]
	>=media-libs/libwebp-0.4.0:=
	sys-libs/zlib:=[minizip]
	kerberos? ( virtual/krb5 )
"
# For nvidia-drivers blocker, see bug #413637 .
RDEPEND="${COMMON_DEPEND}
	!<dev-util/electron-0.36.12-r4
	x11-misc/xdg-utils
	virtual/opengl
	virtual/ttf-fonts
	x11-libs/gtk+:2
	selinux? ( sec-policy/selinux-chromium )
	tcmalloc? ( !<x11-drivers/nvidia-drivers-331.20 )
"
# dev-vcs/git - https://bugs.gentoo.org/593476
DEPEND="${COMMON_DEPEND}
	>=app-arch/gzip-1.7
	!arm? (
		dev-lang/yasm
	)
	dev-lang/perl
	dev-perl/JSON
	>=dev-util/gperf-3.0.3
	dev-util/ninja
	net-libs/nodejs
	sys-apps/hwids[usb(+)]
	>=sys-devel/bison-2.4.3
	sys-devel/flex
	virtual/pkgconfig
	dev-vcs/git
	x11-libs/gtk+:2
	x11-libs/gtk+:3
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

pre_build_checks() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		local -x CPP="$(tc-getCXX) -E"
		if tc-is-clang && ! version_is_at_least "3.9.1" "$(clang-fullversion)"; then
			# bugs: #601654
			die "At least clang 3.9.1 is required"
		fi
		if tc-is-gcc && ! version_is_at_least 4.9 "$(gcc-version)"; then
			# bugs: #535730, #525374, #518668, #600288
			die "At least gcc 4.9 is required"
		fi
	fi

	# LTO pass requires more file descriptors
	if use lto; then
		local lto_n_rlimit_min="16384"
		local maxfiles=$(ulimit -n -H)
		if [ "${maxfiles}" -lt "${lto_n_rlimit_min}" ]; then
			eerror ""
			eerror "Building with USE=\"lto\" requires file descriptor" \
				"limit to be no less than ${lto_n_rlimit_min}."
			eerror "The current limit for portage is ${maxfiles}."
			eerror "Please add the following to /etc/security/limits.conf:"
			eerror ""
			eerror "   root hard    nofile  ${lto_n_rlimit_min}"
			eerror "   root soft    nofile  ${lto_n_rlimit_min}"
			eerror ""
			die
		fi
	fi

	# Check build requirements, bug #541816 and bug #471810 .
	CHECKREQS_MEMORY="3G"
	use lto && CHECKREQS_MEMORY="7G"
	CHECKREQS_DISK_BUILD="5G"
	eshopts_push -s extglob
	if is-flagq '-g?(gdb)?([1-9])'; then
		CHECKREQS_DISK_BUILD="25G"
		CHECKREQS_MEMORY="16G"
	fi
	eshopts_pop
	check-reqs_pkg_pretend
}

pkg_pretend() {
	pre_build_checks
}

pkg_setup() {
	pre_build_checks

	# Make sure the build system will use the right python, bug #344367.
	python-any-r1_pkg_setup

	chromium_suid_sandbox_check_kernel_config
}

_unnest_patches() {
	local _s="${1%/}/" relpath out

	for f in $(find "${_s}" -mindepth 2 -name *.patch -printf \"%P\"\\n); do
		relpath="$(dirname ${f})"
		out="${_s}/${relpath////_}_$(basename ${f})"
		sed -r -e "s|^([-+]{3}) (.*)$|\1 ${relpath}/\2 ${f}|g" > "${out}"
	done
}

_get_install_suffix() {
	local c=(${SLOT//\// })
	local slot=${c[0]}
	local suffix

	if [[ "${slot}" == "0" ]]; then
		suffix=""
	else
		suffix="-${slot}"
	fi

	echo -n "${suffix}"
}

_get_install_dir() {
	echo -n "/usr/$(get_libdir)/electron$(_get_install_suffix)"
}

_get_target_arch() {
	local myarch="$(tc-arch)"
	local target_arch

	if [[ $myarch = amd64 ]] ; then
		target_arch=x64
	elif [[ $myarch = x86 ]] ; then
		target_arch=ia32
	elif [[ $myarch = arm64 ]] ; then
		target_arch=arm64
	elif [[ $myarch = arm ]] ; then
		target_arch=arm
	else
		die "Failed to determine target arch, got '$myarch'."
	fi

	echo -n "${target_arch}"
}

src_prepare() {
	mv "${WORKDIR}/${CHROMIUM_P}" "${CHROMIUM_S}" || die
	rm -r "${NODE_S}" &&
		mv "${WORKDIR}/${NODE_P}" "${NODE_S}" || die
	rm -r "${BREAKPAD_S}" &&
		mv "${WORKDIR}/${BREAKPAD_P}" "${BREAKPAD_S}" || die
	rm -r "${BREAKPAD_SRC_S}" &&
		mv "${WORKDIR}/${BREAKPAD_SRC_P}/src" "${BREAKPAD_SRC_S}" || die
	rm -r "${BRIGHTRAY_S}" &&
		mv "${WORKDIR}/${BRIGHTRAY_P}" "${BRIGHTRAY_S}" || die
	rm -r "${NATIVE_MATE_S}" &&
		mv "${WORKDIR}/${NATIVE_MATE_P}" "${NATIVE_MATE_S}" || die
	rm -r "${PDF_VIEWER_S}" &&
		mv "${WORKDIR}/${PDF_VIEWER_P}" "${PDF_VIEWER_S}" || die
	rm -r "${GRIT_S}" &&
		mv "${WORKDIR}/${GRIT_P}" "${GRIT_S}" || die
	rm -r "${LIBCC_S}" &&
		mv "${WORKDIR}/${LIBCHROMIUMCONTENT_P}" "${LIBCC_S}" || die
	rsync -a "${WORKDIR}/${ASAR_P}/node_modules/" \
		"${S}/node_modules/" || die
	rsync -a "${WORKDIR}/${BROWSERIFY_P}/node_modules/" \
        "${S}/node_modules/" || die

	# electron patches
	cd "${ELECTRON_S}" || die
	eapply "${FILESDIR}/${P}.patch"

	# node patches
	cd "${NODE_S}" || die
	eapply "${FILESDIR}/${P}-vendor-node.patch"
	eapply "${FILESDIR}/${PN}-vendor-node-external-snapshots-r2.patch"
	# make sure node uses the correct version of v8
	rm -r deps/v8 || die
	ln -s "${CHROMIUM_S}/v8" deps/ || die

	# make sure we use python2.* while using gyp
	sed -i -e "s/python/${EPYTHON}/" \
		deps/npm/node_modules/node-gyp/gyp/gyp || die
	sed -i -e "s/|| 'python'/|| '${EPYTHON}'/" \
		deps/npm/node_modules/node-gyp/lib/configure.js || die

	python_fix_shebang "${CHROMIUM_S}/build/gyp_chromium"
	python_fix_shebang "${S}/tools/"

	# less verbose install output (stating the same as portage, basically)
	sed -i -e "/print/d" tools/install.py || die

	# proper libdir, hat tip @ryanpcmcquen
	# https://github.com/iojs/io.js/issues/504
	local LIBDIR=$(get_libdir)
	sed -i -e "s|lib/|${LIBDIR}/|g" tools/install.py || die
	sed -i -e "s/'lib'/'${LIBDIR}'/" lib/module.js || die
	sed -i -e "s|\"lib\"|\"${LIBDIR}\"|" deps/npm/lib/npm.js || die

	# brightray patches
	cd "${BRIGHTRAY_S}" || die
	eapply "${FILESDIR}/${P}-vendor-brightray.patch"

	# libchromiumcontent patches
	cd "${LIBCC_S}" || die
	eapply "${FILESDIR}/${P}-vendor-libchromiumcontent.patch"

	# chromium patches
	cd "${CHROMIUM_S}" || die

	eapply "${FILESDIR}/chromium-FORTIFY_SOURCE.patch"
	eapply "${FILESDIR}/chromium-glibc-2.24.patch"
	eapply "${FILESDIR}/chromium-56-gcc4.patch"
	eapply "${FILESDIR}/chromium-system-ffmpeg-r4.patch"
	eapply "${FILESDIR}/chromium-disable-widevine.patch"
	eapply "${FILESDIR}/chromium-remove-gardiner-mod-font-r1.patch"
	eapply "${FILESDIR}/chromium-shared-v8-r2.patch"
	eapply "${FILESDIR}/chromium-lto-fixes-r3.patch"

	# libcc chromium patches
	_unnest_patches "${LIBCC_S}/patches"

	EPATCH_SOURCE="${LIBCC_S}/patches" \
	EPATCH_SUFFIX="patch" \
	EPATCH_FORCE="yes" \
	EPATCH_EXCLUDE="third_party_icu*" \
	EPATCH_MULTI_MSG="Applying libchromiumcontent patches..." \
		epatch

	# Merge chromiumcontent component into chromium source tree.
	mkdir -p "${CHROMIUM_S}/chromiumcontent" || die
	cp -a "${LIBCC_S}/chromiumcontent" "${CHROMIUM_S}/" || die
	cp -a "${LIBCC_S}/tools/linux/" "${CHROMIUM_S}/tools/" || die

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
		third_party/libusb
		third_party/libwebm
		third_party/libxml/chromium
		third_party/libyuv
		third_party/lss
		third_party/lzma_sdk
		third_party/markupsafe
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
		third_party/ply
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
		keeplibs+=( third_party/ffmpeg )
	fi

	# Remove most bundled libraries. Some are still needed.
	build/linux/unbundle/remove_bundled_libraries.py \
		"${keeplibs[@]}" --do-remove || die

	cd "${S}" || die

	eapply_user
}

src_configure() {
	local myconf_gn=""
	local myconf_gyp=""

	cd "${CHROMIUM_S}" || die

	# GN needs explicit config for Debug/Release as opposed to inferring it from build directory.
	myconf_gn+=" is_debug=false"

	# Disable nacl, we can't build without pnacl (http://crbug.com/269560).
	myconf_gn+=" enable_nacl=false"

	# Use system-provided libraries.
	# TODO: use_system_hunspell (upstream changes needed).
	# TODO: use_system_libsrtp (bug #459932).
	# TODO: use_system_libusb (http://crbug.com/266149).
	# TODO: use_system_opus (https://code.google.com/p/webrtc/issues/detail?id=3077).
	# TODO: use_system_protobuf (bug #525560).
	# TODO: use_system_ssl (http://crbug.com/58087).
	# TODO: use_system_sqlite (http://crbug.com/22208).

	# libevent: https://bugs.gentoo.org/593458
	local gn_system_libraries="
		flac
		harfbuzz-ng
		icu
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

	# Optional dependencies.
	myconf_gn+=" use_cups=$(usex cups true false)"
	myconf_gn+=" use_gconf=$(usex gnome true false)"
	myconf_gn+=" use_gnome_keyring=$(usex gnome-keyring true false)"
	myconf_gn+=" use_gtk3=false"
	myconf_gn+=" use_kerberos=$(usex kerberos true false)"
	myconf_gn+=" use_pulseaudio=$(usex pulseaudio true false)"

	# TODO: link_pulseaudio=true for GN.

	myconf_gn+=" fieldtrial_testing_like_official_build=true"

	if tc-is-clang; then
		myconf_gn+=" is_clang=true clang_base_path=\"/usr\" clang_use_chrome_plugins=false"
	else
		myconf_gn+=" is_clang=false"
	fi

	# Never use bundled gold binary. Disable gold linker flags for now.
	# Do not use bundled clang.
	# Trying to use gold results in linker crash.
	myconf_gn+=" use_gold=false use_sysroot=false linux_use_bundled_binutils=false"

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

	local target_arch=$(_get_target_arch)
	local ffmpeg_target_arch="${target_arch}"

	if [[ ${ffmpeg_target_arch} = arm ]]; then
		ffmpeg_target_arch=$(usex neon arm-neon arm)
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

		filter-flags "-Wl,--as-needed"

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

	# https://bugs.gentoo.org/588596
	append-cxxflags $(test-flags-CXX -fno-delete-null-pointer-checks)

	# Define a custom toolchain for GN
	myconf_gn+=" custom_toolchain=\"${FILESDIR}/toolchain:default\""

	use lto && myconf_gn+=" allow_posix_link_time_opt=true"

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
		chromium/scripts/generate_gn.py || die
		popd > /dev/null || die
	fi

	third_party/libaddressinput/chromium/tools/update-strings.py || die

	touch chrome/test/data/webui/i18n_process_css_test.html || die

	einfo "Configuring bundled nodejs..."
	pushd "${S}/vendor/node" > /dev/null || die
	# Make sure gyp_node does not run
	echo '#!/usr/bin/env python' > tools/gyp_node.py || die
	# --shared-libuv cannot be used as electron's node fork
	# patches uv_loop structure.
	./configure --shared --without-bundled-v8 --shared-openssl \
		--shared-http-parser --shared-zlib --without-npm \
		--with-intl=system-icu --without-dtrace \
		--dest-cpu=${target_arch} --prefix="" || die
	popd > /dev/null || die

	# libchromiumcontent configuration
	myconf_gn+=" root_extra_deps = [\"//chromiumcontent:chromiumcontent\"]"
	myconf_gn+=" is_electron_build = true"
	myconf_gn+=" is_component_build = false"

	einfo "Configuring chromiumcontent..."
	# TODO: bootstrapped gn binary hangs when using tcmalloc with portage's sandbox.
	tools/gn/bootstrap/bootstrap.py -v --gn-gen-args "${myconf_gn} use_allocator=\"none\"" || die
	# Remove the glibc allocator shim so that it doesn't get picked up
	# by Electron's build_libs script.
	rm out/Release/obj/base/allocator/unified_allocator_shim/allocator_shim_default_dispatch_to_glibc.o || die

	myconf_gn+=" use_allocator=$(usex tcmalloc \"tcmalloc\" \"none\")"
	out/Release/gn gen --args="${myconf_gn}" out/Release || die

	cd "${S}" || die
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
	"$@" || die
}

src_compile() {
	local compile_target="${S}/out/R"
	local myconf_gyp=""
	local chromium_target="${CHROMIUM_S}/out/Release"
	local libcc_path="${S}/vendor/brightray/vendor/libchromiumcontent"
	local libcc_dist_path="${libcc_path}/dist/main"
	local libcc_dist_static_path="${libcc_dist_path}/static_library"
	local libcc_dist_shared_path="${libcc_dist_path}/shared_library"
	local libcc_output="${CHROMIUM_S}/out/Release/obj/chromiumcontent"
	local libcc_output_shared="${libcc_output}-shared"
	local target_arch=$(_get_target_arch)

	tc-export AR CC CXX NM

	mkdir -p "${compile_target}" || die

	cd "${CHROMIUM_S}" || die

	# Build mksnapshot and pax-mark it.
	eninja -C "${chromium_target}" mksnapshot || die
	pax-mark m "${chromium_target}/mksnapshot"

	# Build chromedriver.
	eninja -C "${chromium_target}" chromedriver
	cp -a "${chromium_target}/chromedriver" "${compile_target}/" || die

	# Build libchromiumcontent components.
	eninja -C "${chromium_target}" chromiumcontent:chromiumcontent

	cd "${S}" || die

	# Gather and prepare built components of libchromiumcontent.
	CHROMIUM_BUILD_DIR="${chromium_target}" \
	python2 "${libcc_path}"/script/create-dist \
		--target_arch=${target_arch} \
		--component=static_library \
		--no_zip || die

	# v8 is built as a shared library, so copy it manually
	# for generate_filenames_gypi to find.
	mkdir -p "${libcc_dist_shared_path}" || die
	cp "${chromium_target}/libv8.so" "${libcc_dist_shared_path}" || die

	python2 "${libcc_path}"/tools/generate_filenames_gypi.py \
		"${libcc_dist_path}/filenames.gypi" \
		"${CHROMIUM_S}" \
		"${libcc_dist_shared_path}" \
		"${libcc_dist_static_path}"

	# Configure electron.
	myconf_gyp+="
		$(gyp_use cups)
		$(gyp_use gnome use_gconf)
		$(gyp_use gnome-keyring use_gnome_keyring)
		$(gyp_use gnome-keyring linux_link_gnome_keyring)
		$(gyp_use lto)"

	if [[ $(tc-getCC) == *clang* ]]; then
		myconf_gyp+=" -Dclang=1"
	else
		myconf_gyp+=" -Dclang=0"
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

	myconf_gyp+=" -Dtarget_arch=${target_arch}"

	# Make sure that -Werror doesn't get added to CFLAGS by the build system.
	# Depending on GCC version the warnings are different and we don't want
	# the build to fail because of that.
	myconf_gyp+=" -Dwerror="

	# Disable fatal linker warnings, bug 506268.
	myconf_gyp+=" -Ddisable_fatal_linker_warnings=1"

	# Needed for system icu - we don't need additional data files.
	myconf_gyp+=" -Dicu_use_data_file_flag=0"
	myconf_gyp+=" -Dgenerate_character_data=0"

	myconf_gyp+=" -Dlibchromiumcontent_component=0"
	myconf_gyp+=" -Dcomponent=static_library"
	myconf_gyp+=" -Dlibrary=static_library"
	myconf_gyp+=" -Ivendor/node/config.gypi -Icommon.gypi electron.gyp"

	EGYP_CHROMIUM_COMMAND="${CHROMIUM_S}/build/gyp_chromium" \
		egyp_chromium ${myconf_gyp} || die

	# Copy libv8 and snapshot files so the node binary can find them.
	mkdir -p "${compile_target}/lib/" || die
	cp "${chromium_target}/libv8.so" "${compile_target}/lib/" || die
	cp "${chromium_target}/natives_blob.bin" "${compile_target}" || die
	cp "${chromium_target}/snapshot_blob.bin" "${compile_target}" || die

	# Copy generated shim headers.
	mkdir -p "${compile_target}/gen" || die
	cp -r "${chromium_target}/gen/shim_headers" \
		"${compile_target}/gen" || die

	# Build the Node binary and pax-mark it.
	eninja -C ${compile_target} nodebin
	pax-mark m ${compile_target}/nodebin

	# Finally, build Electron.
	eninja -C ${compile_target} electron
	pax-mark m ${compile_target}/electron

	echo "v${PV}" > ${compile_target}/version
}

src_install() {
	local install_dir="$(_get_install_dir)"
	local install_suffix="$(_get_install_suffix)"
	local LIBDIR="${ED}/usr/$(get_libdir)"

	pushd out/R/locales > /dev/null || die
	chromium_remove_language_paks
	popd > /dev/null || die

	# Install Electron
	insinto "${install_dir}"
	exeinto "${install_dir}"
	newexe out/R/nodebin node
	doexe out/R/electron
	doexe out/R/chromedriver
	doins out/R/libv8.so
	doins out/R/libnode.so
	fperms +x "${install_dir}/libv8.so" "${install_dir}/libnode.so"
	doins out/R/natives_blob.bin
	doins out/R/snapshot_blob.bin
	doins out/R/blink_image_resources_200_percent.pak
	doins out/R/content_resources_200_percent.pak
	doins out/R/content_shell.pak
	doins out/R/pdf_viewer_resources.pak
	doins out/R/ui_resources_200_percent.pak
	doins out/R/views_resources_200_percent.pak
	doins -r out/R/resources
	doins -r out/R/locales
	dosym "${install_dir}/electron" "/usr/bin/electron${install_suffix}"

	doins out/R/version

	# Install Node headers
	HEADERS_ONLY=1 \
		"${S}/vendor/node/tools/install.py" install "${ED}" "/usr" || die
	# set up a symlink structure that npm expects..
	dodir /usr/include/node/deps/{v8,uv}
	dosym . /usr/include/node/src
	for var in deps/{uv,v8}/include; do
		dosym ../.. /usr/include/node/${var}
	done

	dodir "/usr/include/electron${install_suffix}"
	mv "${ED}/usr/include/node" \
	   "${ED}/usr/include/electron${install_suffix}/node" || die
}

pkg_postinst() {
	electron-config update
}

pkg_postrm() {
	electron-config update
}
