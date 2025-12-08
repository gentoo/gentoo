# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit xdg cmake python-any-r1 optfeature flag-o-matic

DESCRIPTION="Official desktop client for Telegram"
HOMEPAGE="https://desktop.telegram.org https://github.com/telegramdesktop/tdesktop"

MY_P="tdesktop-${PV}-full"
SRC_URI="https://github.com/telegramdesktop/tdesktop/releases/download/v${PV}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD GPL-3-with-openssl-exception LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~loong"
IUSE="dbus enchant +fonts +libdispatch screencast wayland webkit +X"

CDEPEND="
	!net-im/telegram-desktop-bin
	app-arch/lz4:=
	dev-cpp/abseil-cpp:=
	dev-cpp/ada:=
	dev-cpp/cld3:=
	>=dev-cpp/glibmm-2.77:2.68
	dev-libs/glib:2
	dev-libs/openssl:=
	>=dev-libs/protobuf-21.12
	dev-libs/qr-code-generator:=
	dev-libs/xxhash
	>=dev-qt/qtbase-6.5:6=[dbus?,gui,network,opengl,ssl,wayland?,widgets,X?]
	>=dev-qt/qtimageformats-6.5:6
	>=dev-qt/qtsvg-6.5:6
	media-libs/libjpeg-turbo:=
	media-libs/openal
	media-libs/opus
	media-libs/rnnoise
	>=media-libs/tg_owt-0_pre20241202:=[screencast=,X=]
	>=media-video/ffmpeg-6:=[opus,vpx]
	net-libs/tdlib:=[tde2e]
	virtual/minizip:=
	kde-frameworks/kcoreaddons:6
	!enchant? ( >=app-text/hunspell-1.7:= )
	enchant? ( app-text/enchant:= )
	libdispatch? ( dev-libs/libdispatch )
	webkit? ( wayland? (
		>=dev-qt/qtdeclarative-6.5:6
		>=dev-qt/qtwayland-6.5:6[compositor(+),qml]
	) )
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
	>=dev-cpp/ms-gsl-4.1.0
	dev-cpp/expected
	dev-cpp/expected-lite
	dev-cpp/range-v3
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-build/cmake-3.16
	>=dev-cpp/cppgir-2.0_p20240315
	>=dev-libs/gobject-introspection-1.82.0-r2
	dev-util/gdbus-codegen
	virtual/pkgconfig
	wayland? ( dev-util/wayland-scanner )
"
# NOTE: dev-cpp/expected-lite used indirectly by a dev-cpp/cppgir header file

PATCHES=(
	"${FILESDIR}"/tdesktop-5.2.2-qt6-no-wayland.patch
	"${FILESDIR}"/tdesktop-5.2.2-libdispatch.patch
	"${FILESDIR}"/tdesktop-5.7.2-cstring.patch
	"${FILESDIR}"/tdesktop-5.8.3-cstdint.patch
	"${FILESDIR}"/tdesktop-5.14.3-system-cppgir.patch
	"${FILESDIR}"/tdesktop-6.3.2-loosen-minizip.patch
)

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if has ccache ${FEATURES}; then
			ewarn "ccache does not work with ${PN} out of the box"
			ewarn "due to usage of precompiled headers"
			ewarn "check bug https://bugs.gentoo.org/715114 for more info"
			ewarn
		fi
	fi
}

src_prepare() {
	# Happily fail if libraries aren't found...
	find -type f \( -name 'CMakeLists.txt' -o -name '*.cmake' \) \
		\! -path './cmake/external/qt/package.cmake' \
		-print0 | xargs -0 sed -i \
		-e '/pkg_check_modules(/s/[^ ]*)/REQUIRED &/' \
		-e '/find_package(/s/)/ REQUIRED)/' \
		-e '/find_library(/s/)/ REQUIRED)/' || die
	# Make sure to check the excluded files for new
	# CMAKE_DISABLE_FIND_PACKAGE entries.

	# Some packages are found through pkg_check_modules, rather than find_package
	sed -e '/find_package(lz4 /d' -i cmake/external/lz4/CMakeLists.txt || die
	sed -e '/find_package(Opus /d' -i cmake/external/opus/CMakeLists.txt || die
	sed -e '/find_package(xxHash /d' -i cmake/external/xxhash/CMakeLists.txt || die

	# Greedily remove ThirdParty directories, keep only ones that interest us
	local keep=(
		rlottie  # Patched, not recommended to unbundle by upstream
		libprisma  # Telegram-specific library, no stable releases
		tgcalls  # Telegram-specific library, no stable releases
		xdg-desktop-portal  # Only a few xml files are used with gdbus-codegen
	)
	for x in Telegram/ThirdParty/*; do
		has "${x##*/}" "${keep[@]}" || rm -r "${x}" || die
	done

	# Control QtDBus dependency from here, to avoid messing with QtGui.
	# QtGui will use find_package to find QtDbus as well, which
	# conflicts with the -DCMAKE_DISABLE_FIND_PACKAGE method.
	if ! use dbus; then
		sed -e '/find_package(Qt[^ ]* OPTIONAL_COMPONENTS/s/DBus *//' \
			-i cmake/external/qt/package.cmake || die
	fi

	# Control automagic dep only needed when USE="webkit wayland"
	if ! use webkit || ! use wayland; then
		sed -e 's/QT_CONFIG(wayland_compositor_quick)/0/' \
			-i Telegram/lib_webview/webview/platform/linux/webview_linux_compositor.h || die
	fi

	# Shut the CMake 4 QA checker up by removing unused CMakeLists files
	rm Telegram/ThirdParty/rlottie/CMakeLists.txt || die
	rm cmake/external/glib/cppgir/expected-lite/example/CMakeLists.txt || die
	rm cmake/external/glib/cppgir/expected-lite/test/CMakeLists.txt || die
	rm cmake/external/glib/cppgir/expected-lite/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	# Having user paths sneak into the build environment through the
	# XDG_DATA_DIRS variable causes all sorts of weirdness with cppgir:
	# - bug 909038: can't read from flatpak directories (fixed upstream)
	# - bug 920819: system-wide directories ignored when variable is set
	export XDG_DATA_DIRS="${ESYSROOT}/usr/share"

	# Evil flag (See https://bugs.gentoo.org/919201)
	filter-flags -fno-delete-null-pointer-checks

	# The ABI of media-libs/tg_owt breaks if the -DNDEBUG flag doesn't keep
	# the same state across both projects.
	# See https://bugs.gentoo.org/866055
	append-cppflags -DNDEBUG

	# https://github.com/telegramdesktop/tdesktop/issues/17437#issuecomment-1001160398
	use !libdispatch && append-cppflags -DCRL_FORCE_QT

	local no_webkit_wayland=$(use webkit && use wayland && echo no || echo yes)
	local use_webkit_wayland=$(use webkit && use wayland && echo yes || echo no)
	local mycmakeargs=(
		-DQT_VERSION_MAJOR=6

		# Override new cmake.eclass defaults (https://bugs.gentoo.org/921939)
		# Upstream never tests this any other way
		-DCMAKE_DISABLE_PRECOMPILE_HEADERS=OFF

		# Control automagic dependencies on certain packages
		## These libraries are only used in lib_webview, for wayland
		## See Telegram/lib_webview/webview/platform/linux/webview_linux_compositor.h
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Quick=${no_webkit_wayland}
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6QuickWidgets=${no_webkit_wayland}
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6WaylandCompositor=${no_webkit_wayland}

		# Make sure dependencies that aren't patched to be REQUIRED in
		# src_prepare, are found.  This was suggested to me by the telegram
		# devs, in lieu of having explicit flags in the build system.
		-DCMAKE_REQUIRE_FIND_PACKAGE_Qt6DBus=$(usex dbus)
		-DCMAKE_REQUIRE_FIND_PACKAGE_Qt6Quick=${use_webkit_wayland}
		-DCMAKE_REQUIRE_FIND_PACKAGE_Qt6QuickWidgets=${use_webkit_wayland}
		-DCMAKE_REQUIRE_FIND_PACKAGE_Qt6WaylandCompositor=${use_webkit_wayland}

		-DDESKTOP_APP_DISABLE_QT_PLUGINS=ON
		-DDESKTOP_APP_DISABLE_X11_INTEGRATION=$(usex !X)
		## Enables enchant and disables hunspell
		-DDESKTOP_APP_USE_ENCHANT=$(usex enchant)
		## Use system fonts instead of bundled ones
		-DDESKTOP_APP_USE_PACKAGED_FONTS=$(usex !fonts)
		## See tdesktop-*-libdispatch.patch
		-DDESKTOP_APP_USE_LIBDISPATCH=$(usex libdispatch)
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

src_compile() {
	# There's a bug where sometimes, it will rebuild/relink during src_install
	# Make sure that happens here, instead.
	cmake_build
	cmake_build
}

pkg_postinst() {
	xdg_pkg_postinst
	if ! use X && ! use screencast; then
		ewarn "both the 'X' and 'screencast' USE flags are disabled, screen sharing won't work!"
		ewarn
	fi
	if ! use libdispatch; then
		ewarn "Disabling USE=libdispatch may cause performance degradation"
		ewarn "due to fallback to poor QThreadPool! Please see"
		ewarn "https://github.com/telegramdesktop/tdesktop/wiki/The-Packaged-Building-Mode"
		ewarn
	fi
	optfeature_header
	optfeature "AVIF, HEIF and JpegXL image support" kde-frameworks/kimageformats:6[avif,heif,jpegxl]
}
