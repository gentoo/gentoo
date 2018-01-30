# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit multiprocessing pax-utils python-any-r1 qt5-build

DESCRIPTION="Library for rendering dynamic web content in Qt5 C++ and QML applications"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

IUSE="alsa bindist geolocation pax_kernel pulseaudio +system-ffmpeg system-icu widgets"

RDEPEND="
	app-arch/snappy:=
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	~dev-qt/qtcore-${PV}
	~dev-qt/qtdeclarative-${PV}
	~dev-qt/qtgui-${PV}
	~dev-qt/qtnetwork-${PV}
	~dev-qt/qtwebchannel-${PV}[qml]
	dev-libs/expat
	dev-libs/libevent:=
	dev-libs/libxml2
	dev-libs/libxslt
	dev-libs/protobuf:=
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz:=
	media-libs/libpng:0=
	>=media-libs/libvpx-1.5:=[svc]
	media-libs/libwebp:=
	media-libs/mesa
	media-libs/opus
	net-libs/libsrtp:0=
	sys-apps/dbus
	sys-apps/pciutils
	sys-libs/libcap
	sys-libs/zlib[minizip]
	virtual/jpeg:0
	virtual/libudev
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	alsa? ( media-libs/alsa-lib )
	geolocation? ( ~dev-qt/qtpositioning-${PV} )
	pulseaudio? ( media-sound/pulseaudio:= )
	system-ffmpeg? ( media-video/ffmpeg:0= )
	system-icu? ( <dev-libs/icu-59:= )
	widgets? ( ~dev-qt/qtwidgets-${PV} )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-util/gperf
	dev-util/ninja
	dev-util/re2c
	sys-devel/bison
	pax_kernel? ( sys-apps/elfix )
"

PATCHES=(
	"${FILESDIR}/${PN}-5.7.1-fix-audio-detection.patch"
	"${FILESDIR}/${PN}-5.7.0-fix-system-ffmpeg.patch"
	"${FILESDIR}/${PN}-5.7.0-icu58.patch"
	"${FILESDIR}/${PN}-5.7.0-undef-madv_free.patch"
	"${FILESDIR}/${PN}-5.7.1-gcc-7.patch"
)

src_prepare() {
	use pax_kernel && PATCHES+=( "${FILESDIR}/${PN}-paxmark-mksnapshot.patch" )

	if use system-icu; then
		# ensure build against system headers - bug #601264
		rm -r src/3rdparty/chromium/third_party/icu/source || die
	fi

	qt_use_disable_mod geolocation positioning \
		src/core/core_common.pri \
		src/core/core_gyp_generator.pro

	qt_use_disable_mod widgets widgets src/src.pro

	qt5-build_src_prepare
}

src_configure() {
	export NINJA_PATH=/usr/bin/ninja
	export NINJAFLAGS="${NINJAFLAGS:--j$(makeopts_jobs) -l$(makeopts_loadavg "${MAKEOPTS}" 0) -v}"

	local myqmakeargs=(
		$(usex alsa 'WEBENGINE_CONFIG+=use_alsa' '')
		$(usex bindist '' 'WEBENGINE_CONFIG+=use_proprietary_codecs')
		$(usex pulseaudio 'WEBENGINE_CONFIG+=use_pulseaudio' '')
		$(usex system-ffmpeg 'WEBENGINE_CONFIG+=use_system_ffmpeg' '')
		$(usex system-icu 'WEBENGINE_CONFIG+=use_system_icu' '')
	)
	qt5-build_src_configure
}

src_install() {
	qt5-build_src_install

	# bug 601472
	if [[ ! -f ${D%/}${QT5_LIBDIR}/libQt5WebEngine.so ]]; then
		die "${CATEGORY}/${PF} failed to build anything. Please report to https://bugs.gentoo.org/"
	fi

	pax-mark m "${D%/}${QT5_LIBEXECDIR}"/QtWebEngineProcess
}
