# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit xdg cmake python-any-r1 optfeature flag-o-matic

DESCRIPTION="Official desktop client for Telegram"
HOMEPAGE="https://desktop.telegram.org https://github.com/telegramdesktop/tdesktop"

MY_P="tdesktop-${PV}-full"
SRC_URI="https://github.com/telegramdesktop/tdesktop/releases/download/v${PV}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD GPL-3-with-openssl-exception LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv"
IUSE="dbus enchant +fonts +jemalloc +libdispatch screencast qt6 qt6-imageformats wayland webkit +X"
REQUIRED_USE="
	qt6-imageformats? ( qt6 )
"

KIMAGEFORMATS_RDEPEND="
	media-libs/libavif:=
	media-libs/libheif:=
	>=media-libs/libjxl-0.8.0:=
"
CDEPEND="
	!net-im/telegram-desktop-bin
	app-arch/lz4:=
	dev-cpp/abseil-cpp:=
	dev-cpp/ada:=
	>=dev-cpp/glibmm-2.77:2.68
	dev-libs/glib:2
	dev-libs/openssl:=
	dev-libs/protobuf
	dev-libs/xxhash
	media-libs/libjpeg-turbo:=
	~media-libs/libtgvoip-2.4.4_p20240706
	media-libs/openal
	media-libs/opus
	media-libs/rnnoise
	~media-libs/tg_owt-0_pre20240804:=[screencast=,X=]
	media-video/ffmpeg:=[opus,vpx]
	sys-libs/zlib:=[minizip]
	!enchant? ( >=app-text/hunspell-1.7:= )
	enchant? ( app-text/enchant:= )
	jemalloc? ( dev-libs/jemalloc:= )
	libdispatch? ( dev-libs/libdispatch )
	!qt6? (
		>=dev-qt/qtcore-5.15:5=
		>=dev-qt/qtgui-5.15:5=[dbus?,jpeg,png,wayland?,X?]
		>=dev-qt/qtimageformats-5.15:5
		>=dev-qt/qtnetwork-5.15:5[ssl]
		>=dev-qt/qtsvg-5.15:5
		>=dev-qt/qtwidgets-5.15:5[png,X?]
		kde-frameworks/kcoreaddons:5
		webkit? (
			>=dev-qt/qtdeclarative-5.15:5
			>=dev-qt/qtwayland-5.15:5[compositor(+)]
		)
	)
	qt6? (
		>=dev-qt/qtbase-6.5:6=[dbus?,gui,network,opengl,wayland?,widgets,X?]
		>=dev-qt/qtimageformats-6.5:6
		>=dev-qt/qtsvg-6.5:6
		webkit? (
			>=dev-qt/qtdeclarative-6.5:6
			>=dev-qt/qtwayland-6.5:6[compositor,qml]
		)
		qt6-imageformats? (
			>=dev-qt/qtimageformats-6.5:6=
			${KIMAGEFORMATS_RDEPEND}
		)
	)
	X? (
		x11-libs/libxcb:=
		x11-libs/xcb-util-keysyms
	)
"
RDEPEND="${CDEPEND}
	webkit? ( || ( net-libs/webkit-gtk:4.1 net-libs/webkit-gtk:6 ) )
"
DEPEND="${CDEPEND}
	>=dev-cpp/cppgir-2.0_p20240315
	>=dev-cpp/ms-gsl-4
	dev-cpp/expected-lite
	dev-cpp/range-v3
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-build/cmake-3.16
	>=dev-cpp/cppgir-2.0_p20240315
	dev-util/gdbus-codegen
	virtual/pkgconfig
	wayland? ( dev-util/wayland-scanner )
"

PATCHES=(
	"${FILESDIR}"/tdesktop-4.2.4-jemalloc-only-telegram-r1.patch
	"${FILESDIR}"/tdesktop-4.10.0-system-cppgir.patch
	"${FILESDIR}"/tdesktop-5.2.2-qt6-no-wayland.patch
	"${FILESDIR}"/tdesktop-5.2.2-libdispatch.patch
)

pkg_pretend() {
	if has ccache ${FEATURES}; then
		ewarn "ccache does not work with ${PN} out of the box"
		ewarn "due to usage of precompiled headers"
		ewarn "check bug https://bugs.gentoo.org/715114 for more info"
		ewarn
	fi
}

src_prepare() {
	# Bundle kde-frameworks/kimageformats for qt6, since it's impossible to
	#   build in gentoo right now.
	if use qt6-imageformats; then
		sed -e 's/DESKTOP_APP_USE_PACKAGED_LAZY/TRUE/' -i \
			cmake/external/kimageformats/CMakeLists.txt || die
		printf '%s\n' \
			'Q_IMPORT_PLUGIN(QAVIFPlugin)' \
			'Q_IMPORT_PLUGIN(HEIFPlugin)' \
			'Q_IMPORT_PLUGIN(QJpegXLPlugin)' \
			>> cmake/external/qt/qt_static_plugins/qt_static_plugins.cpp || die
	fi
	# kde-frameworks/kcoreaddons is bundled when using qt6.

	# Happily fail if libraries aren't found...
	find -type f \( -name 'CMakeLists.txt' -o -name '*.cmake' \) \
		\! -path './Telegram/lib_webview/CMakeLists.txt' \
		\! -path './cmake/external/expected/CMakeLists.txt' \
		\! -path './cmake/external/kcoreaddons/CMakeLists.txt' \
		\! -path './cmake/external/qt/package.cmake' \
		-print0 | xargs -0 sed -i \
		-e '/pkg_check_modules(/s/[^ ]*)/REQUIRED &/' \
		-e '/find_package(/s/)/ REQUIRED)/' || die
	# Make sure to check the excluded files for new
	# CMAKE_DISABLE_FIND_PACKAGE entries.

	# Control QtDBus dependency from here, to avoid messing with QtGui.
	# QtGui will use find_package to find QtDbus as well, which
	# conflicts with the -DCMAKE_DISABLE_FIND_PACKAGE method.
	if ! use dbus; then
		sed -e '/find_package(Qt[^ ]* OPTIONAL_COMPONENTS/s/DBus *//' \
			-i cmake/external/qt/package.cmake || die
	fi

	cmake_src_prepare
}

src_configure() {
	# Having user paths sneak into the build environment through the
	# XDG_DATA_DIRS variable causes all sorts of weirdness with cppgir:
	# - bug 909038: can't read from flatpak directories (fixed upstream)
	# - bug 920819: system-wide directories ignored when variable is set
	export XDG_DATA_DIRS="${EPREFIX}/usr/share"

	# Evil flag (bug #919201)
	filter-flags -fno-delete-null-pointer-checks

	# The ABI of media-libs/tg_owt breaks if the -DNDEBUG flag doesn't keep
	# the same state across both projects.
	# See https://bugs.gentoo.org/866055
	append-cppflags '-DNDEBUG'

	# https://github.com/telegramdesktop/tdesktop/issues/17437#issuecomment-1001160398
	use !libdispatch && append-cppflags -DCRL_FORCE_QT

	local qt=$(usex qt6 6 5)
	local mycmakeargs=(
		-DQT_VERSION_MAJOR=${qt}

		# Override new cmake.eclass defaults (https://bugs.gentoo.org/921939)
		# Upstream never tests this any other way
		-DCMAKE_DISABLE_PRECOMPILE_HEADERS=OFF

		# Control automagic dependencies on certain packages
		## Header-only lib, some git version.
		-DCMAKE_DISABLE_FIND_PACKAGE_tl-expected=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt${qt}Quick=$(usex !webkit)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt${qt}QuickWidgets=$(usex !webkit)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt${qt}WaylandClient=$(usex !wayland)
		## Only used in Telegram/lib_webview/CMakeLists.txt
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt${qt}WaylandCompositor=$(usex !webkit)
		## KF6CoreAddons is currently unavailable in ::gentoo
		-DCMAKE_DISABLE_FIND_PACKAGE_KF${qt}CoreAddons=$(usex qt6)

		-DDESKTOP_APP_USE_LIBDISPATCH=$(usex libdispatch)
		-DDESKTOP_APP_DISABLE_X11_INTEGRATION=$(usex !X)
		-DDESKTOP_APP_DISABLE_WAYLAND_INTEGRATION=$(usex !wayland)
		-DDESKTOP_APP_DISABLE_JEMALLOC=$(usex !jemalloc)
		## Enables enchant and disables hunspell
		-DDESKTOP_APP_USE_ENCHANT=$(usex enchant)
		## Use system fonts instead of bundled ones
		-DDESKTOP_APP_USE_PACKAGED_FONTS=$(usex !fonts)
	)

	if [[ -n ${MY_TDESKTOP_API_ID} && -n ${MY_TDESKTOP_API_HASH} ]]; then
		einfo "Found custom API credentials"
		mycmakeargs+=(
			-DTDESKTOP_API_ID="${MY_TDESKTOP_API_ID}"
			-DTDESKTOP_API_HASH="${MY_TDESKTOP_API_HASH}"
		)
	else
		# https://github.com/telegramdesktop/tdesktop/blob/dev/snap/snapcraft.yaml
		# Building with snapcraft API credentials by default
		# Custom API credentials can be obtained here:
		# https://github.com/telegramdesktop/tdesktop/blob/dev/docs/api_credentials.md
		# After getting credentials you can export variables:
		#  export MY_TDESKTOP_API_ID="17349""
		#  export MY_TDESKTOP_API_HASH="344583e45741c457fe1862106095a5eb"
		# and restart the build"
		# you can set above variables (without export) in /etc/portage/env/net-im/telegram-desktop
		# portage will use custom variable every build automatically
		mycmakeargs+=(
			-DTDESKTOP_API_ID="611335"
			-DTDESKTOP_API_HASH="d524b414d21f4d37f08684c1df41ac9c"
		)
	fi

	cmake_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	if ! use X && ! use screencast; then
		ewarn "both the 'X' and 'screencast' USE flags are disabled, screen sharing won't work!"
		ewarn
	fi
	if ! use jemalloc && use elibc_glibc; then
		# https://github.com/telegramdesktop/tdesktop/issues/16084
		# https://github.com/desktop-app/cmake_helpers/pull/91#issuecomment-881788003
		ewarn "Disabling USE=jemalloc on glibc systems may cause very high RAM usage!"
		ewarn "Do NOT report issues about RAM usage without enabling this flag first."
		ewarn
	fi
	if ! use libdispatch; then
		ewarn "Disabling USE=libdispatch may cause performance degradation"
		ewarn "due to fallback to poor QThreadPool! Please see"
		ewarn "https://github.com/telegramdesktop/tdesktop/wiki/The-Packaged-Building-Mode"
		ewarn
	fi
	if use wayland && ! use qt6; then
		ewarn "Wayland-specific integrations have been deprecated with Qt5."
		ewarn "The app will continue to function under wayland, but some"
		ewarn "functionality may be reduced."
		ewarn "These integrations are only supported when built with Qt6."
		ewarn
	fi
	if use qt6 && ! use qt6-imageformats; then
		elog "Enable USE=qt6-imageformats for AVIF, HEIF and JpegXL support"
		elog
	fi
	optfeature_header
	if ! use qt6; then
		optfeature "AVIF, HEIF and JpegXL image support" kde-frameworks/kimageformats[avif,heif,jpegxl]
	fi
}
