# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit multiprocessing python-any-r1 qt5-build

DESCRIPTION="Library for rendering dynamic web content in Qt5 C++ and QML applications"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~x86"
fi

IUSE="alsa bindist designer geolocation jumbo-build kerberos pulseaudio +system-ffmpeg +system-icu widgets"
REQUIRED_USE="designer? ( widgets )"

RDEPEND="
	app-arch/snappy:=
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	~dev-qt/qtcore-${PV}
	~dev-qt/qtdeclarative-${PV}
	~dev-qt/qtgui-${PV}
	~dev-qt/qtnetwork-${PV}
	~dev-qt/qtprintsupport-${PV}
	~dev-qt/qtwebchannel-${PV}[qml]
	dev-libs/expat
	dev-libs/libevent:=
	dev-libs/libxml2[icu]
	dev-libs/libxslt
	dev-libs/re2:=
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz:=
	media-libs/lcms:2
	media-libs/libjpeg-turbo:=
	media-libs/libpng:0=
	>=media-libs/libvpx-1.5:=[svc]
	media-libs/libwebp:=
	media-libs/mesa[egl,X(+)]
	media-libs/opus
	sys-apps/dbus
	sys-apps/pciutils
	sys-libs/zlib[minizip]
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
	designer? ( ~dev-qt/designer-${PV} )
	geolocation? ( ~dev-qt/qtpositioning-${PV} )
	kerberos? ( virtual/krb5 )
	pulseaudio? ( media-sound/pulseaudio:= )
	system-ffmpeg? ( media-video/ffmpeg:0= )
	system-icu? ( >=dev-libs/icu-60.2:= )
	widgets? (
		~dev-qt/qtdeclarative-${PV}[widgets]
		~dev-qt/qtwidgets-${PV}
	)
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	>=app-arch/gzip-1.7
	dev-util/gperf
	dev-util/ninja
	dev-util/re2c
	sys-devel/bison
"

PATCHES=(
	"${FILESDIR}/${PN}-5.14.1-disable-fatal-warnings.patch" # bug 695446
	"${FILESDIR}/${P}-icu67.patch" # bug 720054
	"${FILESDIR}/${P}-gcc-10.patch" # bug 721876
)

src_prepare() {
	if ! use jumbo-build; then
		sed -i -e 's|use_jumbo_build=true|use_jumbo_build=false|' \
			src/buildtools/config/common.pri || die
	fi

	# bug 630834 - pass appropriate options to ninja when building GN
	sed -e "s/\['ninja'/&, '-j$(makeopts_jobs)', '-l$(makeopts_loadavg "${MAKEOPTS}" 0)', '-v'/" \
		-i src/3rdparty/chromium/tools/gn/bootstrap/bootstrap.py || die

	# bug 620444 - ensure local headers are used
	find "${S}" -type f -name "*.pr[fio]" | \
		xargs sed -i -e 's|INCLUDEPATH += |&$${QTWEBENGINE_ROOT}_build/include $${QTWEBENGINE_ROOT}/include |' || die

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

	qt_use_disable_config alsa webengine-alsa src/buildtools/config/linux.pri
	qt_use_disable_config pulseaudio webengine-pulseaudio src/buildtools/config/linux.pri

	qt_use_disable_mod designer webenginewidgets src/plugins/plugins.pro

	qt_use_disable_mod widgets widgets src/src.pro

	qt5-build_src_prepare
}

src_configure() {
	export NINJA_PATH=/usr/bin/ninja
	export NINJAFLAGS="${NINJAFLAGS:--j$(makeopts_jobs) -l$(makeopts_loadavg "${MAKEOPTS}" 0) -v}"

	local myqmakeargs=(
		--
		-printing-and-pdf
		-system-opus
		-system-webp
		$(usex alsa '-alsa' '-no-alsa')
		$(usex bindist '-no-proprietary-codecs' '-proprietary-codecs')
		$(usex geolocation '-webengine-geolocation' '-no-webengine-geolocation')
		$(usex kerberos '-webengine-kerberos' '-no-webengine-kerberos')
		$(usex pulseaudio '-pulseaudio' '-no-pulseaudio')
		$(usex system-ffmpeg '-system-ffmpeg' '-qt-ffmpeg')
		$(usex system-icu '-webengine-icu' '-no-webengine-icu')
	)
	qt5-build_src_configure
}

src_install() {
	qt5-build_src_install

	# bug 601472
	if [[ ! -f ${D}${QT5_LIBDIR}/libQt5WebEngine.so ]]; then
		die "${CATEGORY}/${PF} failed to build anything. Please report to https://bugs.gentoo.org/"
	fi
}
