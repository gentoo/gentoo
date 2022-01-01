# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml(+)"
inherit estack flag-o-matic multiprocessing python-any-r1 qt5-build

DESCRIPTION="Library for rendering dynamic web content in Qt5 C++ and QML applications"
HOMEPAGE="https://www.qt.io/"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"
	if [[ ${PV} == ${QT5_PV}_p* ]]; then
		SRC_URI="https://dev.gentoo.org/~asturm/distfiles/${P}.tar.xz"
		SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${PN}-5.15.2_p20211019-jumbo-build.patch.bz2"
		S="${WORKDIR}/${P}"
		QT5_BUILD_DIR="${S}_build"
	fi
else
	EGIT_BRANCH="5.15"
	EGIT_REPO_URI=(
		"https://code.qt.io/qt/${QT5_MODULE}.git"
		"https://github.com/qt/${QT5_MODULE}.git"
	)
	inherit git-r3
fi

# patchset based on https://github.com/chromium-ppc64le releases
SRC_URI+=" ppc64? ( https://dev.gentoo.org/~gyakovlev/distfiles/${PN}-5.15.2-r1-chromium87-ppc64le.tar.xz )"

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
	=dev-qt/qtcore-${QT5_PV}*
	=dev-qt/qtdeclarative-${QT5_PV}*
	=dev-qt/qtgui-${QT5_PV}*
	=dev-qt/qtnetwork-${QT5_PV}*
	=dev-qt/qtprintsupport-${QT5_PV}*
	=dev-qt/qtwebchannel-${QT5_PV}*[qml]
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz:=
	media-libs/lcms:2
	media-libs/libjpeg-turbo:=
	media-libs/libpng:0=
	>=media-libs/libvpx-1.5:=[svc(+)]
	media-libs/libwebp:=
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
	x11-libs/libxkbfile
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	alsa? ( media-libs/alsa-lib )
	designer? ( =dev-qt/designer-${QT5_PV}* )
	geolocation? ( =dev-qt/qtpositioning-${QT5_PV}* )
	kerberos? ( virtual/krb5 )
	pulseaudio? ( media-sound/pulseaudio:= )
	system-ffmpeg? ( media-video/ffmpeg:0= )
	system-icu? ( >=dev-libs/icu-69.1:= )
	widgets? (
		=dev-qt/qtdeclarative-${QT5_PV}*[widgets]
		=dev-qt/qtwidgets-${QT5_PV}*
	)
"
DEPEND="${RDEPEND}
	media-libs/libglvnd
"
BDEPEND="${PYTHON_DEPS}
	dev-util/gperf
	dev-util/ninja
	dev-util/re2c
	net-libs/nodejs[ssl]
	sys-devel/bison
	sys-devel/flex
	ppc64? ( >=dev-util/gn-0.1807 )
"

PATCHES=(
	"${FILESDIR}/${PN}-5.15.2-disable-fatal-warnings.patch" # downstream, bug 695446
	"${FILESDIR}/${PN}-5.15.2-extra_gn.patch" # downstream, bug 774186
	"${FILESDIR}/${PN}-5.15.2_p20210224-chromium-87-v8-icu68.patch" # downstream, bug 757606
	"${FILESDIR}/${PN}-5.15.2_p20210224-disable-git.patch" # downstream snapshot fix
	"${FILESDIR}/${PN}-5.15.2_p20211015-pdfium-system-lcms2.patch" # by Debian, QTBUG-61746
	"${FILESDIR}/${PN}-5.15.2_p20210824-abseil-cpp-glibc-2.34.patch" # bug 811312
	"${FILESDIR}/${PN}-5.15.2_p20210824-breakpad-glibc-2.34.patch" # bug 811312
	"${WORKDIR}/${PN}-5.15.2_p20211019-jumbo-build.patch" # bug 813957
)

pkg_preinst() {
	elog "This version of Qt WebEngine is based on Chromium version 87.0.4280, with"
	elog "additional security fixes from newer versions. Extensive as it is, the"
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

	case ${QT5_BUILD_TYPE} in
		live)    git-r3_src_unpack ;&
		release) default ;;
	esac
}

src_prepare() {
	if [[ ${PV} == ${QT5_PV}_p* ]]; then
		# This is made from git, and for some reason will fail w/o .git directories.
		mkdir -p .git src/3rdparty/chromium/.git || die
	fi
	# We need to make sure this integrates well into Qt 5.15.2 installation.
	# Otherwise revdeps fail w/o heavy changes. This is the simplest way to do it.
	# See also: https://www.qt.io/blog/building-qt-webengine-against-other-qt-versions
	sed -e "/^MODULE_VERSION/s/5\.15\.[3456789]/${QT5_PV}/" -i .qmake.conf || die

	# QTBUG-88657 - jumbo-build could still make trouble
	if ! use jumbo-build; then
		sed -i -e 's|use_jumbo_build=true|use_jumbo_build=false|' \
			src/buildtools/config/common.pri || die
	fi

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
		eapply "${FILESDIR}/qtwebengine-5.15.2-enable-ppc64.patch"
		pushd src/3rdparty/chromium > /dev/null || die
		eapply -p0 "${WORKDIR}/${PN}-ppc64le"
		popd > /dev/null || die
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
		$(qt_use alsa)
		$(qt_use !bindist proprietary-codecs)
		$(qt_use geolocation webengine-geolocation)
		$(qt_use kerberos webengine-kerberos)
		$(qt_use pulseaudio)
		$(usex system-ffmpeg -system-ffmpeg -qt-ffmpeg)
		$(qt_use system-icu webengine-icu)
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
