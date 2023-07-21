# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="xml(+)"
CHROMIUM_VER="108.0.5359.181"
CHROMIUM_PATCHES_VER="114.0.5735.133"

inherit check-reqs estack flag-o-matic multiprocessing python-any-r1 qt6-build

DESCRIPTION="Library for rendering dynamic web content in Qt6 C++ and QML applications"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64"
fi

IUSE="
	alsa bindist designer geolocation +jumbo-build kerberos pulseaudio screencast
	+system-icu widgets
"
REQUIRED_USE="designer? ( widgets )"

BDEPEND="
	$(python_gen_any_dep 'dev-python/html5lib[${PYTHON_USEDEP}]')
	dev-util/gperf
	dev-util/ninja
	dev-util/re2c
	net-libs/nodejs[ssl]
	sys-devel/bison
	sys-devel/flex
"
RDEPEND="
	app-arch/snappy:=
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	dev-libs/expat
	dev-libs/libevent:=
	dev-libs/libxml2[icu]
	dev-libs/libxslt
	dev-libs/re2:=
	=dev-qt/qtdeclarative-${PV}*
	=dev-qt/qtwebchannel-${PV}*
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz:=
	media-libs/lcms:2
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	>=media-libs/libvpx-1.5:=[svc(+)]
	media-libs/libwebp:=
	media-libs/openjpeg:2=
	media-libs/opus
	sys-apps/dbus
	sys-apps/pciutils
	sys-libs/zlib[minizip]
	virtual/libudev
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libxcb:=
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libxkbcommon
	x11-libs/libxkbfile
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXScrnSaver
	x11-libs/libxshmfence:=
	x11-libs/libXtst
	alsa? ( media-libs/alsa-lib )
	geolocation? ( =dev-qt/qtpositioning-${PV}* )
	kerberos? ( virtual/krb5 )
	pulseaudio? ( media-libs/libpulse:= )
	screencast? ( media-video/pipewire:= )
	system-icu? ( >=dev-libs/icu-69.1:= )
	widgets? (
		=dev-qt/qtbase-${PV}*[widgets]
	)
"
DEPEND="${RDEPEND}
	media-libs/libglvnd
"

python_check_deps() {
	python_has_version "dev-python/html5lib[${PYTHON_USEDEP}]"
}

qtwebengine_check-reqs() {
	# bug #307861
	eshopts_push -s extglob
	if is-flagq '-g?(gdb)?([1-9])'; then
		ewarn "You have enabled debug info (probably have -g or -ggdb in your CFLAGS/CXXFLAGS)."
		ewarn "You may experience really long compilation times and/or increased memory usage."
		ewarn "If compilation fails, please try removing -g/-ggdb before reporting a bug."
	fi
	eshopts_pop

	[[ ${MERGE_TYPE} == binary ]] && return

	# (check-reqs added for bug #570534)
	#
	# Estimate the amount of RAM required
	# Multiplier is *10 because Bash doesn't do floating point maths.
	# Let's crudely assume ~2GB per compiler job for GCC.
	local multiplier=20

	# And call it ~1.5GB for Clang.
	if tc-is-clang ; then
		multiplier=15
	fi

	local CHECKREQS_DISK_BUILD="7G"
	local CHECKREQS_DISK_USR="150M"
	if ! has "distcc" ${FEATURES} ; then
		# bug #830661
		# Not super realistic to come up with good estimates for distcc right now
		local CHECKREQS_MEMORY=$(($(makeopts_jobs)*multiplier/10))G
	fi

	check-reqs_${EBUILD_PHASE_FUNC}
}

pkg_pretend() {
	qtwebengine_check-reqs
}

pkg_setup() {
	qtwebengine_check-reqs
	python-any-r1_pkg_setup
}

pkg_preinst() {
	elog "This version of Qt WebEngine is based on Chromium version ${CHROMIUM_VER}, with"
	elog "additional security fixes up to ${CHROMIUM_PATCHES_VER}. Extensive as it is, the"
	elog "list of backports is impossible to evaluate, but always bound to be behind"
	elog "Chromium's release schedule."
	elog "In addition, various online services may deny service based on an outdated"
	elog "user agent version (and/or other checks). Google is already known to do so."
	elog
	elog "tldr: Your web browsing experience will be compromised."
}

src_unpack() {
	# bug 307861
	eshopts_push -s extglob
	if is-flagq '-g?(gdb)?([1-9])'; then
		ewarn
		ewarn "You have enabled debug info (probably have -g or -ggdb in your CFLAGS/CXXFLAGS)."
		ewarn "You may experience really long compilation times and/or increased memory usage."
		ewarn "If compilation fails, please try removing -g/-ggdb before reporting a bug."
		ewarn
	fi
	eshopts_pop

	case ${QT6_BUILD_TYPE} in
		live)    git-r3_src_unpack ;&
		release) default ;;
	esac
}

src_prepare() {
	# bug 620444 - ensure local headers are used
	find . -type f -name "*.pr[fio]" -exec \
		sed -i -e 's|INCLUDEPATH += |&$${QTWEBENGINE_ROOT}_build/include $${QTWEBENGINE_ROOT}/include |' {} + || die

	if use system-icu; then
		# Sanity check to ensure that bundled copy of ICU is not used.
		# Whole src/3rdparty/chromium/third_party/icu directory cannot be deleted because
		# src/3rdparty/chromium/third_party/icu/BUILD.gn is used by build system.
		# If usage of headers of bundled copy of ICU occurs, then lists of shim headers in
		# shim_headers("icui18n_shim") and shim_headers("icuuc_shim") in
		# src/3rdparty/chromium/third_party/icu/BUILD.gn should be updated.
		local file
		while read file; do
			echo "#error This file should not be used!" > "${file}" || die
		done < <(find src/3rdparty/chromium/third_party/icu -type f "(" -name "*.c" -o -name "*.cpp" -o -name "*.h" ")" 2>/dev/null)
	fi

	qt6-build_src_prepare
}

src_configure() {
	export NINJA_PATH="${BROOT}"/usr/bin/ninja
	export NINJAFLAGS="${NINJAFLAGS:--j$(makeopts_jobs) -l$(makeopts_loadavg "${MAKEOPTS}" 0) -v}"

	local mycmakeargs=(
		#-DQT_FEATURE_accessibility=off
		#-DQT_FEATURE_force_asserts=off
		#-DQT_FEATURE_opengl=off
		#-DQT_FEATURE_printer=off
		-DQT_FEATURE_qtpdf_build=off
		-DQT_FEATURE_qtpdf_quick_build=off
		-DQT_FEATURE_qtpdf_widgets_build=off
		-DQT_FEATURE_qtwebengine_build=on
		-DQT_FEATURE_qtwebengine_quick_build=on
		-DQT_FEATURE_qtwebengine_widgets_build=on
		#-DQT_FEATURE_ssl=off
		#-DQT_FEATURE_static=off
		#-DQT_FEATURE_system_zlib=off
		#-DQT_FEATURE_system_png=off
		#-DQT_FEATURE_system_jpeg=off
		#-DQT_FEATURE_system_freetype=off
		#-DQT_FEATURE_system_harfbuzz=off
		#-DQT_FEATURE_use_gold_linker=off
		#-DQT_FEATURE_use_lld_linker=off
		-DQT_FEATURE_webengine_embedded_build=off
		-DQT_FEATURE_webengine_extensions=on
		#-DQT_FEATURE_webengine_full_debug_info=$(usex debug)
		-DQT_FEATURE_webengine_geolocation=$(usex geolocation on off)
		-DQT_FEATURE_webengine_jumbo_build=$(usex jumbo-build)
		#-DQT_FEATURE_webengine_jumbo_file_merge_limit
		-DQT_FEATURE_webengine_kerberos=$(usex kerberos on off)
		-DQT_FEATURE_webengine_native_spellchecker=off
		-DQT_FEATURE_webengine_ozone_x11=on
		-DQT_FEATURE_webengine_pepper_plugins=on
		-DQT_FEATURE_webengine_proprietary_codecs=$(usex bindist off on)
		-DQT_FEATURE_webengine_printing_and_pdf=on
		-DQT_FEATURE_webengine_sanitizer=on
		-DQT_FEATURE_webengine_spellchecker=on
		-DQT_FEATURE_webengine_system_opus=on
		-DQT_FEATURE_webengine_system_libwebp=on
		-DQT_FEATURE_webengine_system_alsa=$(usex alsa on off)
		-DQT_FEATURE_webengine_system_ffmpeg=off # https://bugs.gentoo.org/831487
		-DQT_FEATURE_webengine_system_icu=$(usex system-icu)
		-DQT_FEATURE_webengine_system_libevent=on
		-DQT_FEATURE_webengine_system_libopenjpeg2=on
		-DQT_FEATURE_webengine_system_libpci=on
		-DQT_FEATURE_webengine_system_libpng=on
		-DQT_FEATURE_webengine_system_pulseaudio=$(usex pulseaudio on off)
		-DQT_FEATURE_webengine_system_zlib=on
		-DQT_FEATURE_webengine_webchannel=on
		-DQT_FEATURE_webengine_webrtc=on
		-DQT_FEATURE_webengine_webrtc_pipewire=$(usex screencast on off)
		#-DQT_FEATURE_xcb=off
	)

	qt6-build_src_configure
}
