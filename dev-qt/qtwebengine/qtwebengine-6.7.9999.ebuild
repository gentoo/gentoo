# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="xml(+)"
inherit check-reqs flag-o-matic multiprocessing optfeature
inherit prefix python-any-r1 qt6-build toolchain-funcs

DESCRIPTION="Library for rendering dynamic web content in Qt6 C++ and QML applications"
SRC_URI+="
	https://dev.gentoo.org/~ionen/distfiles/${PN}-6.7-patchset-10.tar.xz
"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm64"
fi

IUSE="
	accessibility +alsa bindist custom-cflags designer geolocation
	+jumbo-build kerberos opengl pdfium pulseaudio qml screencast
	+system-icu vaapi vulkan webdriver +widgets
"
REQUIRED_USE="
	designer? ( qml widgets )
"

# dlopen: krb5, libva, pciutils, udev
# gcc: for -latomic
RDEPEND="
	app-arch/snappy:=
	dev-libs/expat
	dev-libs/libevent:=
	dev-libs/libxml2[icu]
	dev-libs/libxslt
	dev-libs/nspr
	dev-libs/nss
	~dev-qt/qtbase-${PV}:6[accessibility=,gui,opengl=,vulkan?,widgets?]
	~dev-qt/qtdeclarative-${PV}:6[widgets?]
	~dev-qt/qtwebchannel-${PV}:6[qml?]
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz:=
	media-libs/lcms:2
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/libwebp:=
	media-libs/mesa[gbm(+)]
	media-libs/openjpeg:2=
	media-libs/opus
	media-libs/tiff:=
	sys-apps/dbus
	sys-apps/pciutils
	sys-devel/gcc:*
	sys-libs/zlib:=[minizip]
	virtual/libudev
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libXtst
	x11-libs/libdrm
	x11-libs/libxcb:=
	x11-libs/libxkbcommon
	x11-libs/libxkbfile
	alsa? ( media-libs/alsa-lib )
	designer? ( ~dev-qt/qttools-${PV}:6[designer] )
	geolocation? ( ~dev-qt/qtpositioning-${PV}:6 )
	kerberos? ( virtual/krb5 )
	pulseaudio? ( media-libs/libpulse[glib] )
	screencast? (
		dev-libs/glib:2
		media-video/pipewire:=
	)
	system-icu? ( dev-libs/icu:= )
	vaapi? ( media-libs/libva:=[X] )
	!vaapi? ( media-libs/libvpx:= )
"
DEPEND="
	${RDEPEND}
	media-libs/libglvnd
	x11-base/xorg-proto
	x11-libs/libXcursor
	x11-libs/libXi
	x11-libs/libxshmfence
	opengl? ( media-libs/libglvnd[X] )
	screencast? ( media-libs/libepoxy[egl(+)] )
	pdfium? ( net-print/cups )
	test? (
		widgets? ( app-text/poppler[cxx(+)] )
	)
	vaapi? (
		vulkan? ( dev-util/vulkan-headers )
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
[[ ${PV} == 6.9999 ]] || # too fragile for 6.9999, but keep for 6.x.9999
	PATCHES+=( "${WORKDIR}"/patches/chromium )

PATCHES+=(
	# add extras as needed here, may merge in set if carries across versions
	"${FILESDIR}"/${PN}-6.7.2-QTBUG-113574.patch
	"${FILESDIR}"/${PN}-6.7.2-clang19.patch
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

	local CHECKREQS_DISK_BUILD=8G
	local CHECKREQS_DISK_USR=360M

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
		$(qt_feature webdriver webenginedriver)
		$(qt_feature widgets qtpdf_widgets_build)
		$(usev pdfium -DQT_FEATURE_pdf_v8=ON)

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
		$(qt_feature vaapi webengine_vaapi)
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

		# use bundled re2 to avoid complications, may revisit
		# (see discussions in https://github.com/gentoo/gentoo/pull/32281)
		-DQT_FEATURE_webengine_system_re2=OFF

		# bundled is currently required when using vaapi (forced regardless)
		$(qt_feature !vaapi webengine_system_libvpx)

		# not necessary to pass these (default), but in case detection fails
		$(printf -- '-DQT_FEATURE_webengine_system_%s=ON ' \
			freetype gbm glib harfbuzz lcms2 libevent libjpeg \
			libopenjpeg2 libpci libpng libtiff libwebp libxml \
			minizip opus poppler snappy zlib)

		# TODO: fixup gn cross, or package dev-qt/qtwebengine-gn with =ON
		-DINSTALL_GN=OFF
	)

	local mygnargs=(
		# prefer no dlopen where possible
		$(usev pulseaudio link_pulseaudio=true)
		$(usev screencast rtc_link_pipewire=true)
		# reduce default disk space usage
		symbol_level=0
	)

	if use !custom-cflags; then
		strip-flags # fragile

		if is-flagq '-g?(gdb)?([2-9])'; then #914475
			replace-flags '-g?(gdb)?([2-9])' -g1
			ewarn "-g2+/-ggdb* *FLAGS replaced with -g1 (enable USE=custom-cflags to keep)"
		fi

		# Built helpers segfault when using (at least) -march=armv8-a+pauth
		# (bug #920555, #920568 -- suspected gcc bug). For now, filter all
		# for simplicity. Override with USE=custom-cflags if wanted, please
		# report if above -march works again so can cleanup.
		use arm64 && tc-is-gcc && filter-flags '-march=*' '-mcpu=*'
	fi

	# Workaround for build failure with clang-18 and -march=native without
	# avx512. Does not affect e.g. -march=skylake, only native (bug #931623).
	# TODO: drop this when <=llvm-18.1.5-r1 >=18 been gone for some time
	use amd64 && tc-is-clang && is-flagq -march=native &&
		[[ $(clang-major-version) -ge 18 ]] &&
		has_version '<sys-devel/llvm-18.1.5-r1' &&
		tc-cpp-is-true "!defined(__AVX512F__)" ${CXXFLAGS} &&
		append-flags -mevex512

	export NINJA NINJAFLAGS=$(get_NINJAOPTS)
	[[ ${NINJA_VERBOSE^^} == OFF ]] || NINJAFLAGS+=" -v"

	local -x EXTRA_GN="${mygnargs[*]} ${EXTRA_GN}"
	einfo "Extra Gn args: ${EXTRA_GN}"

	qt6-build_src_configure
}

src_compile() {
	# tentatively work around a possible (rare) race condition (bug #921680)
	cmake_build WebEngineCore_sync_all_public_headers

	cmake_src_compile
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
		tst_qwebengineglobalsettings
		tst_qwebengineview
		# fails with offscreen rendering, may be worth retrying if the issue
		# persist given these are rather major tests (or consider virtx)
		tst_qmltests
		tst_qwebenginepage
		# certs verfication seems flaky and gives expiration warnings
		tst_qwebengineclientcertificatestore
		# test is misperformed when qtbase is built USE=-test?
		tst_touchinput
		# currently requires webenginedriver to be already installed
		tst_webenginedriver
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

src_install() {
	qt6-build_src_install

	[[ -e ${D}${QT6_LIBDIR}/libQt6WebEngineCore.so ]] || #601472
		die "${CATEGORY}/${PF} failed to build anything. Please report to https://bugs.gentoo.org/"

	if use test && use webdriver; then
		rm -- "${D}${QT6_BINDIR}"/testbrowser || die
	fi
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
