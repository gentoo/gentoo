# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
QTVER=$(ver_cut 1-3)
inherit multiprocessing python-any-r1 qt5-build

DESCRIPTION="Library for rendering dynamic web content in Qt5 C++ and QML applications"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm arm64 x86"
	if [[ ${PV} == ${QTVER}_p* ]]; then
		SRC_URI="https://dev.gentoo.org/~asturm/distfiles/${P}.tar.xz"
		S="${WORKDIR}/${P}"
		QT5_BUILD_DIR="${S}_build"
	fi
fi

# patchset based on https://github.com/chromium-ppc64le releases
SRC_URI+=" ppc64? ( https://dev.gentoo.org/~gyakovlev/distfiles/${PN}-5.15.2-ppc64.tar.xz )"

IUSE="alsa bindist designer geolocation +jumbo-build kerberos pulseaudio +system-ffmpeg +system-icu widgets"
REQUIRED_USE="designer? ( widgets )"

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
	~dev-qt/qtcore-${QTVER}
	~dev-qt/qtdeclarative-${QTVER}
	~dev-qt/qtgui-${QTVER}
	~dev-qt/qtnetwork-${QTVER}
	~dev-qt/qtprintsupport-${QTVER}
	~dev-qt/qtwebchannel-${QTVER}[qml]
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz:=
	media-libs/lcms:2
	media-libs/libjpeg-turbo:=
	media-libs/libpng:0=
	>=media-libs/libvpx-1.5:=[svc(+)]
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
	designer? ( ~dev-qt/designer-${QTVER} )
	geolocation? ( ~dev-qt/qtpositioning-${QTVER} )
	kerberos? ( virtual/krb5 )
	pulseaudio? ( media-sound/pulseaudio:= )
	system-ffmpeg? ( media-video/ffmpeg:0= )
	system-icu? ( >=dev-libs/icu-68.2:= )
	widgets? (
		~dev-qt/qtdeclarative-${QTVER}[widgets]
		~dev-qt/qtwidgets-${QTVER}
	)
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	>=app-arch/gzip-1.7
	dev-util/gperf
	dev-util/ninja
	dev-util/re2c
	net-libs/nodejs[ssl]
	sys-devel/bison
"

PATCHES=(
	"${FILESDIR}/${PN}-5.15.0-disable-fatal-warnings.patch" # bug 695446
	"${FILESDIR}/${P}-fix-crash-w-app-locales.patch" # bug 773919, QTBUG-91715
	"${FILESDIR}/${P}-chromium-87-v8-icu68.patch" # downstream, bug 757606
	"${FILESDIR}/${P}-disable-git.patch" # downstream snapshot fix
)

src_prepare() {
	if [[ ${PV} == ${QTVER}_p* ]]; then
		# This is made from git, and for some reason will fail w/o .git directories.
		mkdir -p .git src/3rdparty/chromium/.git || die

		# We need to make sure this integrates well into Qt 5.15.2 installation.
		# Otherwise revdeps fail w/o heavy changes. This is the simplest way to do it.
		sed -e "/^MODULE_VERSION/s/5.*/${QTVER}/" -i .qmake.conf || die
	fi

	# QTBUG-88657 - jumbo-build could still make trouble
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

	# we need to generate ppc64 stuff because upstream does not ship it yet
	if use ppc64; then
		einfo "Patching for ppc64le and generating build files"
		eapply "${WORKDIR}/${PN}-ppc64"
		pushd src/3rdparty/chromium/third_party/libvpx > /dev/null || die
		mkdir -vp source/config/linux/ppc64 || die
		mkdir -p source/libvpx/test || die
		touch source/libvpx/test/test.mk || die
		./generate_gni.sh || die
		popd >/dev/null || die
	fi
}

src_configure() {
	export NINJA_PATH=/usr/bin/ninja
	export NINJAFLAGS="${NINJAFLAGS:--j$(makeopts_jobs) -l$(makeopts_loadavg "${MAKEOPTS}" 0) -v}"

	local myqmakeargs=(
		--
		-no-build-qtpdf
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
