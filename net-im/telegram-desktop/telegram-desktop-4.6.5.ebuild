# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit xdg cmake python-any-r1 optfeature flag-o-matic

DESCRIPTION="Official desktop client for Telegram"
HOMEPAGE="https://desktop.telegram.org"

MY_P="tdesktop-${PV}-full"
SRC_URI="https://github.com/telegramdesktop/tdesktop/releases/download/v${PV}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD GPL-3-with-openssl-exception LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv"
IUSE="+dbus enchant +fonts +jemalloc screencast qt6 qt6-imageformats wayland +X"
REQUIRED_USE="
	qt6-imageformats? ( qt6 )
"

KIMAGEFORMATS_RDEPEND="
	media-libs/libavif:=
	media-libs/libheif:=
	media-libs/libjxl
"
RDEPEND="
	!net-im/telegram-desktop-bin
	app-arch/lz4:=
	dev-cpp/abseil-cpp:=
	dev-libs/glib:2
	dev-libs/libdispatch
	dev-libs/libsigc++:2
	dev-libs/openssl:=
	dev-libs/xxhash
	media-libs/fontconfig:=
	media-libs/libjpeg-turbo:=
	~media-libs/libtgvoip-2.4.4_p20221208
	media-libs/openal
	media-libs/opus:=
	media-libs/rnnoise
	~media-libs/tg_owt-0_pre20230105:=[screencast=,X=]
	media-video/ffmpeg:=[opus,vpx]
	sys-libs/zlib:=[minizip]
	virtual/opengl
	dbus? ( dev-cpp/glibmm:2.68 )
	!enchant? ( >=app-text/hunspell-1.7:= )
	enchant? ( app-text/enchant:= )
	jemalloc? ( dev-libs/jemalloc:=[-lazy-lock] )
	!qt6? (
		>=dev-qt/qtcore-5.15:5
		>=dev-qt/qtgui-5.15:5[dbus?,jpeg,png,wayland?,X?]
		>=dev-qt/qtimageformats-5.15:5
		>=dev-qt/qtnetwork-5.15:5[ssl]
		>=dev-qt/qtsvg-5.15:5
		>=dev-qt/qtwidgets-5.15:5[png,X?]
		kde-frameworks/kcoreaddons:=
	)
	qt6? (
		dev-qt/qt5compat:6
		dev-qt/qtbase:6[dbus?,gui,network,opengl,widgets,X?]
		dev-qt/qtimageformats:6
		dev-qt/qtsvg:6
		wayland? ( dev-qt/qtwayland:6 )
		qt6-imageformats? ( ${KIMAGEFORMATS_RDEPEND} )
	)
	X? (
		x11-libs/libxcb:=
		x11-libs/xcb-util-keysyms
	)
"
DEPEND="${RDEPEND}
	dev-cpp/range-v3
	>=dev-cpp/ms-gsl-4
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-util/cmake-3.16
	virtual/pkgconfig
"
# dev-libs/jemalloc:=[-lazy-lock] -> https://bugs.gentoo.org/803233

PATCHES=(
	"${FILESDIR}/tdesktop-4.2.4-jemalloc-only-telegram.patch"
	"${FILESDIR}/tdesktop-4.4.1-fix-dupe-main-decl.patch"
)

# Current desktop-file-utils-0.26 does not understand Version=1.5
QA_DESKTOP_FILE="usr/share/applications/${PN}.desktop"

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
		printf "%s\n" \
			'Q_IMPORT_PLUGIN(QAVIFPlugin)' \
			'Q_IMPORT_PLUGIN(HEIFPlugin)' \
			'Q_IMPORT_PLUGIN(QJpegXLPlugin)' \
			>> cmake/external/qt/qt_static_plugins/qt_static_plugins.cpp || die
	fi

	# kde-frameworks/kcoreaddons is bundled when using qt6, see:
	#   cmake/external/kcoreaddons/CMakeLists.txt

	cmake_src_prepare
}

src_configure() {
	# The ABI of media-libs/tg_owt breaks if the -DNDEBUG flag doesn't keep
	# the same state across both projects.
	# See https://bugs.gentoo.org/866055
	append-cppflags '-DNDEBUG'

	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_tl-expected=ON  # header only lib, some git version. prevents warnings.
		-DQT_VERSION_MAJOR=$(usex qt6 6 5)

		-DDESKTOP_APP_DISABLE_DBUS_INTEGRATION=$(usex !dbus)
		-DDESKTOP_APP_DISABLE_X11_INTEGRATION=$(usex !X)
		-DDESKTOP_APP_DISABLE_WAYLAND_INTEGRATION=$(usex !wayland)
		-DDESKTOP_APP_DISABLE_JEMALLOC=$(usex !jemalloc)
		-DDESKTOP_APP_USE_ENCHANT=$(usex enchant)  # enables enchant and disables hunspell
		-DDESKTOP_APP_USE_PACKAGED_FONTS=$(usex !fonts)  # use system fonts instead of bundled ones
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
	if has_version '<dev-qt/qtcore-5.15.2-r10'; then
		ewarn "Versions of dev-qt/qtcore lower than 5.15.2-r10 might cause telegram"
		ewarn "to crash when pasting big images from the clipboard."
		ewarn
	fi
	if ! use jemalloc && use elibc_glibc; then
		# https://github.com/telegramdesktop/tdesktop/issues/16084
		# https://github.com/desktop-app/cmake_helpers/pull/91#issuecomment-881788003
		ewarn "Disabling USE=jemalloc on glibc systems may cause very high RAM usage!"
		ewarn "Do NOT report issues about RAM usage without enabling this flag first."
		ewarn
	fi
	if use qt6; then
		ewarn "Qt6 support in gentoo is experimental."
		ewarn "Please report any issues you may find, but don't expect"
		ewarn "everything to work correctly as of yet."
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
	optfeature "shop payment support (requires USE=dbus enabled)" net-libs/webkit-gtk:4
	if ! use qt6; then
		optfeature "AVIF, HEIF and JpegXL image support" kde-frameworks/kimageformats[avif,heif,jpegxl]
	fi
}
