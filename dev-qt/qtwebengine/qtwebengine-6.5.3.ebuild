# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# py3.12: uses imp and distutils among potentially more issues, refer to
# www-client/chromium for when adding/backporting support may be viable
PYTHON_COMPAT=( python3_{10..11} )
PYTHON_REQ_USE="xml(+)"
inherit check-reqs flag-o-matic multiprocessing optfeature
inherit prefix python-any-r1 qt6-build toolchain-funcs

DESCRIPTION="Library for rendering dynamic web content in Qt6 C++ and QML applications"
SRC_URI+="
	https://dev.gentoo.org/~ionen/distfiles/${PN}-6.5-patchset-1.tar.xz
"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64"
fi

IUSE="
	+alsa bindist custom-cflags designer geolocation +jumbo-build kerberos
	opengl pdfium pulseaudio qml screencast +system-icu vulkan +widgets
"
REQUIRED_USE="
	designer? ( qml widgets )
"

# dlopen: krb5, pciutils, udev
RDEPEND="
	app-arch/snappy:=
	dev-libs/expat
	dev-libs/libevent:=
	dev-libs/libxml2[icu]
	dev-libs/libxslt
	dev-libs/nspr
	dev-libs/nss
	~dev-qt/qtbase-${PV}:6[gui,opengl=,vulkan?,widgets?]
	~dev-qt/qtwebchannel-${PV}:6[qml?]
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz:=
	media-libs/lcms:2
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/libvpx:=
	media-libs/libwebp:=
	media-libs/openjpeg:2=
	media-libs/opus
	sys-apps/dbus
	sys-apps/pciutils
	sys-libs/zlib:=[minizip]
	virtual/libudev
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libXtst
	x11-libs/libxcb:=
	x11-libs/libxkbcommon
	x11-libs/libxkbfile
	alsa? ( media-libs/alsa-lib )
	designer? ( ~dev-qt/qttools-${PV}:6[designer] )
	geolocation? ( ~dev-qt/qtpositioning-${PV}:6 )
	kerberos? ( virtual/krb5 )
	pulseaudio? ( media-libs/libpulse[glib] )
	qml? ( ~dev-qt/qtdeclarative-${PV}:6 )
	screencast? (
		dev-libs/glib:2
		media-libs/mesa[gbm(+)]
		media-video/pipewire:=
		x11-libs/libdrm
	)
	system-icu? ( dev-libs/icu:= )
	widgets? ( ~dev-qt/qtdeclarative-${PV}:6[widgets] )
"
DEPEND="
	${RDEPEND}
	media-libs/libglvnd
	x11-base/xorg-proto
	x11-libs/libxshmfence
	screencast? ( media-libs/libepoxy[egl(+)] )
	pdfium? ( net-print/cups )
	test? (
		widgets? ( app-text/poppler[cxx(+)] )
	)
"
BDEPEND="
	$(python_gen_any_dep 'dev-python/html5lib[${PYTHON_USEDEP}]')
	dev-util/gperf
	net-libs/nodejs[ssl]
	sys-devel/bison
	sys-devel/flex
"

PATCHES=( "${WORKDIR}"/patches/${PN} )
[[ ${PV} == 6.9999 ]] || # keep for 6.x.9999
	PATCHES+=( "${WORKDIR}"/patches/chromium )

PATCHES+=(
	# add extras as needed here, may merge in set if carries across versions
	"${FILESDIR}"/${PN}-6.5.2-libcxx17.patch
)

python_check_deps() {
	python_has_version "dev-python/html5lib[${PYTHON_USEDEP}]"
}

qtwebengine_check-reqs() {
	[[ ${MERGE_TYPE} == binary ]] && return

	if is-flagq '-g?(gdb)?([1-9])'; then #307861
		ewarn
		ewarn "Used CFLAGS/CXXFLAGS seem to enable debug info (-g or -ggdb), which"
		ewarn "is non-trivial with ${PN}. May experience extended compilation"
		ewarn "times, increased disk/memory usage, and potentially link failure."
		ewarn
		ewarn "If run into issues, please try disabling before reporting a bug."
	fi

	local CHECKREQS_DISK_BUILD=7G
	local CHECKREQS_DISK_USR=220M

	if ! has distcc ${FEATURES}; then #830661
		# assume ~2GB per job or 1.5GB if clang, possible with less
		# depending on free memory and *FLAGS, but prefer being safe as
		# users having OOM issues with qtwebengine been rather common
		tc-is-clang && : 15 || : 20
		local CHECKREQS_MEMORY=$(($(makeopts_jobs)*_/10))G
	fi

	check-reqs_${EBUILD_PHASE_FUNC} #570534
}

pkg_pretend() {
	qtwebengine_check-reqs
}

pkg_setup() {
	qtwebengine_check-reqs
	python-any-r1_pkg_setup
}

src_prepare() {
	qt6-build_src_prepare

	# for www-plugins/chrome-binary-plugins (widevine) search paths on prefix
	hprefixify -w /Gentoo/ src/core/content_client_qt.cpp

	# store chromium versions, only used in postinst for a warning
	local chromium
	mapfile -t chromium < CHROMIUM_VERSION || die
	[[ ${chromium[1]} =~ ^Based.*:[^0-9]+([0-9.]+$) ]] &&
		QT6_CHROMIUM_VER=${BASH_REMATCH[1]} || die
	[[ ${chromium[2]} =~ ^Patched.+:[^0-9]+([0-9.]+$) ]] &&
		QT6_CHROMIUM_PATCHES_VER=${BASH_REMATCH[1]} || die
}

src_configure() {
	local mycmakeargs=(
		$(qt_feature pdfium qtpdf_build)
		$(qt_feature qml qtpdf_quick_build)
		$(qt_feature widgets qtpdf_widgets_build)

		-DQT_FEATURE_qtwebengine_build=ON
		$(qt_feature qml qtwebengine_quick_build)
		$(qt_feature widgets qtwebengine_widgets_build)

		$(cmake_use_find_package designer Qt6Designer)

		$(qt_feature alsa webengine_system_alsa)
		$(qt_feature !bindist webengine_proprietary_codecs)
		$(qt_feature geolocation webengine_geolocation)
		$(qt_feature jumbo-build webengine_jumbo_build)
		$(qt_feature kerberos webengine_kerberos)
		$(qt_feature pulseaudio webengine_system_pulseaudio)
		$(qt_feature screencast webengine_webrtc_pipewire)
		$(qt_feature system-icu webengine_system_icu)
		$(qt_feature vulkan webengine_vulkan)
		-DQT_FEATURE_webengine_embedded_build=OFF
		-DQT_FEATURE_webengine_extensions=ON
		-DQT_FEATURE_webengine_ozone_x11=ON # needed, cannot do optional X yet
		-DQT_FEATURE_webengine_pepper_plugins=ON
		-DQT_FEATURE_webengine_printing_and_pdf=ON
		-DQT_FEATURE_webengine_spellchecker=ON
		-DQT_FEATURE_webengine_webchannel=ON
		-DQT_FEATURE_webengine_webrtc=ON

		# needs a modified ffmpeg to be usable, and even then it may not
		# cooperate with new major ffmpeg versions (bug #831487)
		-DQT_FEATURE_webengine_system_ffmpeg=OFF

		# preemptively using bundled to avoid complications, may revisit
		# (see discussions in https://github.com/gentoo/gentoo/pull/32281)
		-DQT_FEATURE_webengine_system_re2=OFF

		# not necessary to pass these (default), but in case detection fails
		$(printf -- '-DQT_FEATURE_webengine_system_%s=ON ' \
			freetype glib harfbuzz lcms2 libevent libjpeg \
			libopenjpeg2 libpci libpng libvpx libwebp libxml \
			minizip opus poppler snappy zlib)

		# TODO: fixup gn cross, or package dev-qt/qtwebengine-gn with =ON
		-DINSTALL_GN=OFF
	)

	local mygnargs=(
		# prefer no dlopen where possible
		link_pulseaudio=true
		rtc_link_pipewire=true
	)

	if use !custom-cflags; then
		strip-flags # fragile

		if is-flagq '-g?(gdb)?([2-9])'; then #914475
			replace-flags '-g?(gdb)?([2-9])' -g1
			ewarn "-g2+/-ggdb* *FLAGS replaced with -g1 (enable USE=custom-cflags to keep)"
		fi
	fi

	export NINJA NINJAFLAGS=$(get_NINJAOPTS)
	[[ ${NINJA_VERBOSE^^} == OFF ]] || NINJAFLAGS+=" -v"

	local -x EXTRA_GN="${mygnargs[*]} ${EXTRA_GN}"
	einfo "Extra Gn args: ${EXTRA_GN}"

	qt6-build_src_configure
}

src_test() {
	if [[ ${EUID} == 0 ]]; then
		# almost every tests fail, so skip entirely
		ewarn "Skipping tests due to running as root (chromium refuses this configuration)."
		return
	fi

	local CMAKE_SKIP_TESTS=(
		# fails with network sandbox
		tst_loadsignals
		tst_qquickwebengineview
		tst_qwebengineview
		# certs verfication seems flaky and gives expiration warnings
		tst_qwebengineclientcertificatestore
	)

	# prevent using the system's qtwebengine
	# (use glob to avoid unnecessary complications with arch dir)
	local resources=( "${BUILD_DIR}/src/core/${CMAKE_BUILD_TYPE}/"* )
	[[ -d ${resources[0]} ]] || die "invalid resources path: ${resources[0]}"
	local -x QTWEBENGINEPROCESS_PATH=${BUILD_DIR}${QT6_LIBEXECDIR#"${QT6_PREFIX}"}/QtWebEngineProcess
	local -x QTWEBENGINE_LOCALES_PATH=${resources[0]}/qtwebengine_locales
	local -x QTWEBENGINE_RESOURCES_PATH=${resources[0]}

	# random failures in several tests without -j1
	qt6-build_src_test -j1
}

pkg_postinst() {
	# plugin may also be found in $HOME if provided by chrome or firefox
	use amd64 &&
		optfeature "Widevine DRM support (protected media playback)" \
			www-plugins/chrome-binary-plugins

	elog
	elog "This version of Qt WebEngine is based on Chromium version ${QT6_CHROMIUM_VER}, with"
	elog "additional security fixes up to ${QT6_CHROMIUM_PATCHES_VER}. Extensive as it is, the"
	elog "list of backports is impossible to evaluate, but always bound to be behind"
	elog "Chromium's release schedule."
	elog
	elog "In addition, various online services may deny service based on an outdated"
	elog "user agent version (and/or other checks). Google is already known to do so."
	elog
	elog "tl;dr your web browsing experience will be compromised."
}
