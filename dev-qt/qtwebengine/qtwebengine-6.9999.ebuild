# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit check-reqs flag-o-matic multiprocessing optfeature
inherit prefix python-any-r1 qt6-build toolchain-funcs

DESCRIPTION="Library for rendering dynamic web content in Qt6 C++ and QML applications"
SRC_URI+="
	https://dev.gentoo.org/~ionen/distfiles/${PN}-6.11-patchset-1.tar.xz
"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm64"
fi

IUSE="
	accessibility +alsa bindist custom-cflags designer geolocation
	+jumbo-build kerberos opengl +pdfium pulseaudio qml screencast
	+system-icu vaapi vulkan webdriver +widgets
"
REQUIRED_USE="
	designer? ( qml widgets )
	test? ( widgets )
"

# dlopen: krb5, libva, pciutils
RDEPEND="
	app-arch/snappy:=
	dev-libs/expat
	dev-libs/libxml2:=[icu]
	dev-libs/libxslt
	dev-libs/nspr
	dev-libs/nss
	~dev-qt/qtbase-${PV}:6[accessibility=,gui,opengl=,ssl,vulkan?,widgets?]
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
	virtual/libudev:=
	virtual/minizip:=
	virtual/zlib:=
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
	opengl? ( media-libs/libglvnd[X] )
	pulseaudio? ( media-libs/libpulse[glib] )
	screencast? (
		dev-libs/glib:2
		media-video/pipewire:=
	)
	system-icu? ( dev-libs/icu:= )
	vaapi? ( media-libs/libva:=[X] )
"
DEPEND="
	${RDEPEND}
	|| (
		sys-devel/gcc:*
		llvm-runtimes/libatomic-stub
	)
	media-libs/libglvnd
	x11-base/xorg-proto
	x11-libs/libXcursor
	x11-libs/libXi
	x11-libs/libxshmfence
	elibc_musl? ( sys-libs/queue-standalone )
	screencast? ( media-libs/libepoxy[egl(+)] )
	vaapi? (
		vulkan? ( dev-util/vulkan-headers )
	)
"
BDEPEND="
	$(python_gen_any_dep 'dev-python/html5lib[${PYTHON_USEDEP}]')
	dev-util/gperf
	net-libs/nodejs[icu,ssl]
	sys-devel/bison
	sys-devel/flex
"

PATCHES=( "${WORKDIR}"/patches/${PN} )
[[ ${PV} == 6.9999 ]] || # too fragile for 6.9999, but keep for 6.x.9999
	PATCHES+=( "${WORKDIR}"/patches/chromium )

PATCHES+=(
	# add extras as needed here, may merge in set if carries across versions
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

	local CHECKREQS_DISK_BUILD=11G
	local CHECKREQS_DISK_USR=400M

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
	[[ ${chromium[0]} =~ ^Based.*:[^0-9]+([0-9.]+$) ]] &&
		QT6_CHROMIUM_VER=${BASH_REMATCH[1]} || die
	[[ ${chromium[1]} =~ ^Patched.+:[^0-9]+([0-9.]+$) ]] &&
		QT6_CHROMIUM_PATCHES_VER=${BASH_REMATCH[1]} || die
}

src_configure() {
	local mycmakeargs=(
		$(qt_feature pdfium qtpdf_build)
		$(use pdfium && qt_feature qml qtpdf_quick_build)
		$(use pdfium && qt_feature widgets qtpdf_widgets_build)
		$(usev pdfium -DQT_FEATURE_pdf_v8=ON)

		# TODO?: since 6.9.0, dependency checks have been adjusted to make it
		# easier for webengine to be optional which could be useful if *only*
		# need QtPdf (rare at the moment), would require all revdeps to depend
		# on qtwebengine[webengine(+)]
		-DQT_FEATURE_qtwebengine_build=ON
		$(qt_feature qml qtwebengine_quick_build)
		$(qt_feature webdriver webenginedriver)
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
		# TODO: it may be possible to make x11 optional since 6.8+
		-DQT_FEATURE_webengine_ozone_x11=ON
		-DQT_FEATURE_webengine_pepper_plugins=ON
		-DQT_FEATURE_webengine_printing_and_pdf=ON
		-DQT_FEATURE_webengine_spellchecker=ON
		-DQT_FEATURE_webengine_webchannel=ON
		-DQT_FEATURE_webengine_webrtc=ON

		# needs a modified ffmpeg to be usable (bug #831487), and even then
		# it is picky about codecs/version and system's can lead to unexpected
		# issues (e.g. builds but some files don't play even with support)
		-DQT_FEATURE_webengine_system_ffmpeg=OFF

		# use bundled re2 to avoid complications, Qt has also disabled
		# this by default in 6.7.3+ (bug #913923)
		-DQT_FEATURE_webengine_system_re2=OFF

		# currently seems unused with our configuration, doesn't link and grep
		# seems(?) to imply no dlopen nor using bundled (TODO: check again)
		-DQT_FEATURE_webengine_system_openh264=OFF

		# system_libvpx=ON is intentionally ignored with USE=vaapi which leads
		# to using system's being less tested, prefer disabling for now until
		# vaapi can use it as well
		-DQT_FEATURE_webengine_system_libvpx=OFF

		# not necessary to pass these (default), but in case detection fails
		# given qtbase's force_system_libs does not affect these right now
		$(printf -- '-DQT_FEATURE_webengine_system_%s=ON ' \
			freetype gbm glib harfbuzz lcms2 libjpeg libopenjpeg2 \
			libpci libpng libtiff libudev libwebp libxml minizip \
			opus snappy zlib)

		# TODO: fixup gn cross, or package dev-qt/qtwebengine-gn with =ON
		# (see also BUILD_ONLY_GN option added in 6.8+ for the latter)
		-DINSTALL_GN=OFF

		# TODO: drop this if no longer errors out early during cmake generation
		-DQT_GENERATE_SBOM=OFF
	)

	local mygnargs=(
		# prefer no dlopen where possible
		$(usev pulseaudio link_pulseaudio=true)
		$(usev screencast rtc_link_pipewire=true)
		# reduce default disk space usage
		symbol_level=0
	)

	if use !custom-cflags; then
		# qtwebengine can be rather fragile with *FLAGS
		filter-lto
		strip-flags

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

	# chromium passes this by default, but qtwebengine does not and it may
	# "possibly" get enabled by some paths and cause issues (bug #953111)
	append-ldflags -Wl,-z,noexecstack

	export NINJAFLAGS=$(get_NINJAOPTS)
	[[ ${NINJA_VERBOSE^^} == OFF ]] || NINJAFLAGS+=" -v"

	local -x EXTRA_GN="${mygnargs[*]} ${EXTRA_GN}"
	einfo "Extra Gn args: ${EXTRA_GN}"

	qt6-build_src_configure
}

src_compile() {
	cmake_src_compile

	# exact cause unknown, but >=qtwebengine-6.9.2 started to act as if
	# QtWebEngineProcess is marked USER_FACING despite not set anywhere
	# and this creates a user_facing_tool_links.txt with a broken symlink
	:> "${BUILD_DIR}"/user_facing_tool_links.txt || die
}

src_test() {
	if [[ ${EUID} == 0 ]]; then
		# almost every tests fail, so skip entirely
		ewarn "Skipping tests due to running as root (chromium refuses this configuration)."
		return
	fi

	local CMAKE_SKIP_TESTS=(
		# fails with *-sandbox
		tst_certificateerror
		tst_loadsignals
		tst_qquickwebengineview
		tst_qwebengineglobalsettings
		tst_qwebenginepermission
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

	if use test; then
		local delete=( # sigh
			"${D}${QT6_ARCHDATADIR}"/metatypes/*testmockdelegates*
			"${D}${QT6_ARCHDATADIR}"/modules/*TestMockDelegates*
			"${D}${QT6_BINDIR}"/testbrowser
			"${D}${QT6_LIBDIR}"/{,cmake,pkgconfig}/*TestMockDelegates*
			"${D}${QT6_MKSPECSDIR}"/modules/*testmockdelegates*
			"${D}${QT6_QMLDIR}"/QtWebEngine/TestMockDelegates
		)
		# using -f given not tracking which tests may be skipped or not
		rm -rf -- "${delete[@]}" || die
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
