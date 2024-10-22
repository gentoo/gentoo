# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PATCHSET="${PN}-5.15.14_p20240510-patchset"
PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="xml(+)"
inherit check-reqs estack flag-o-matic multiprocessing python-any-r1 qt5-build toolchain-funcs

DESCRIPTION="Library for rendering dynamic web content in Qt5 C++ and QML applications"
HOMEPAGE="https://www.qt.io/"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm64 ~x86"
	if [[ ${PV} == ${QT5_PV}_p* ]]; then
		SRC_URI="https://dev.gentoo.org/~asturm/distfiles/${PN}-5.15.13_p20240510.tar.xz"
		S="${WORKDIR}/${PN}-5.15.13_p20240510"
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

SRC_URI+=" https://dev.gentoo.org/~asturm/distfiles/${PATCHSET}.tar.xz"

IUSE="alsa bindist designer geolocation +jumbo-build kerberos pulseaudio screencast +system-icu widgets"
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
	pulseaudio? ( media-libs/libpulse )
	screencast? ( media-video/pipewire:= )
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
	app-alternatives/ninja
	$(python_gen_any_dep 'dev-python/html5lib[${PYTHON_USEDEP}]')
	dev-util/gperf
	dev-util/re2c
	net-libs/nodejs[ssl]
	sys-devel/bison
	sys-devel/flex
"

PATCHES=(
	"${WORKDIR}/${PATCHSET}"
	"${FILESDIR}/${PN}-5.15.13_p20240510-gcc15.patch"
	"${FILESDIR}/${P}-re2.patch"
	"${FILESDIR}/${PN}-5.15.14_p20240510-gcc15-cstdint.patch"
	"${FILESDIR}/${PN}-5.15.14_p20240510-gcc15-template-id-cdtor.patch"
)

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

src_unpack() {
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
	# We need to make sure this integrates well into Qt 5.15.3 installation.
	# Otherwise revdeps fail w/o heavy changes. This is the simplest way to do it.
	# See also: https://www.qt.io/blog/building-qt-webengine-against-other-qt-versions
	sed -E "/^MODULE_VERSION/s/5\.15\.[0-9]+/${QT5_PV}/" -i .qmake.conf || die

	# QTBUG-88657 - jumbo-build could still make trouble
	if ! use jumbo-build; then
		sed -i -e 's|use_jumbo_build=true|use_jumbo_build=false|' \
			src/buildtools/config/common.pri || die
	fi

	# bug 620444 - ensure local headers are used
	find "${S}" -type f -name "*.pr[fio]" | \
		xargs sed -i -e 's|INCLUDEPATH += |&$${QTWEBENGINE_ROOT}_build/include $${QTWEBENGINE_ROOT}/include |' || die

	if use system-icu; then
		if has_version ">=dev-libs/icu-75.1"; then
			eapply "${FILESDIR}/${PN}-5.15.14_p20240510-icu-75.patch" # too invasive to apply unconditionally
		fi
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

	# src/3rdparty/gn fails with libc++ due to passing of `-static-libstdc++`
	if tc-is-clang ; then
		if has_version 'sys-devel/clang[default-libcxx(-)]' || has_version 'sys-devel/clang-common[default-libcxx(-)]' ; then
			eapply "${FILESDIR}/${PN}-5.15.2_p20210521-clang-libc++.patch"
		fi
	fi

	qt_use_disable_config alsa webengine-alsa src/buildtools/config/linux.pri
	qt_use_disable_config pulseaudio webengine-pulseaudio src/buildtools/config/linux.pri

	qt_use_disable_mod designer webenginewidgets src/plugins/plugins.pro

	qt_use_disable_mod widgets widgets src/src.pro

	qt5-build_src_prepare
}

src_configure() {
	export NINJA_PATH=/usr/bin/ninja
	export NINJAFLAGS="${NINJAFLAGS:--j$(makeopts_jobs "${MAKEOPTS}" 999) -l$(makeopts_loadavg "${MAKEOPTS}" 0) -v}"

	local myqmakeargs=(
		--
		-no-build-qtpdf
		-printing-and-pdf
		--webengine-python-version=python3
		-system-opus
		-system-webp
		$(qt_use alsa)
		$(qt_use !bindist proprietary-codecs)
		$(qt_use geolocation webengine-geolocation)
		$(qt_use kerberos webengine-kerberos)
		$(qt_use pulseaudio)
		$(usex screencast -webengine-webrtc-pipewire '')
		-qt-ffmpeg # bug 831487
		$(qt_use system-icu webengine-icu)
		-no-webengine-re2 # bug 913923
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

pkg_preinst() {
	elog "This version of Qt WebEngine is based on Chromium version 87.0.4280.144,"
	elog "with additional security fixes from newer versions. Extensive as it is, the"
	elog "list of backports is impossible to evaluate, but always bound to be behind"
	elog "Chromium's release schedule."
	elog "In addition, various online services may deny service based on an outdated"
	elog "user agent version (and/or other checks). Google is already known to do so."
	elog
	elog "tldr: Your web browsing experience will be compromised."
}
