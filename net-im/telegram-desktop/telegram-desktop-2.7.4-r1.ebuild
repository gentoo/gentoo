# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit xdg cmake python-any-r1 flag-o-matic

MY_P="tdesktop-${PV}-full"

DESCRIPTION="Official desktop client for Telegram"
HOMEPAGE="https://desktop.telegram.org"
SRC_URI="https://github.com/telegramdesktop/tdesktop/releases/download/v${PV}/${MY_P}.tar.gz"

LICENSE="BSD GPL-3-with-openssl-exception LGPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc64"
IUSE="+dbus enchant +gtk +hunspell +spell wayland webkit +X"

RDEPEND="
	!net-im/telegram-desktop-bin
	app-arch/lz4:=
	dev-cpp/glibmm:2
	dev-libs/xxhash
	dev-qt/qtcore:5
	dev-qt/qtgui:5[dbus?,jpeg,png,wayland?,X(-)?]
	dev-qt/qtimageformats:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5[png,X(-)?]
	media-fonts/open-sans
	media-libs/fontconfig:=
	media-libs/opus:=
	~media-libs/libtgvoip-2.4.4_p20210302
	media-libs/openal
	~media-libs/tg_owt-0_pre20210422
	media-video/ffmpeg:=[opus]
	sys-libs/zlib:=[minizip]
	dbus? (
		dev-qt/qtdbus:5
		dev-libs/libdbusmenu-qt[qt5(+)]
	)
	enchant? ( app-text/enchant:= )
	gtk? ( x11-libs/gtk+:3[X?] )
	hunspell? ( >=app-text/hunspell-1.7:= )
	wayland? ( kde-frameworks/kwayland:= )
	webkit? ( net-libs/webkit-gtk:= )
	X? ( x11-libs/libxcb:= )
"
DEPEND="${RDEPEND}
	dev-cpp/range-v3
	=dev-cpp/ms-gsl-3*
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-util/cmake-3.16
	virtual/pkgconfig
"
REQUIRED_USE="
	spell? (
		^^ ( enchant hunspell )
	)
"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	# https://github.com/desktop-app/cmake_helpers/pull/91
	# https://github.com/desktop-app/lib_webview/pull/2
	"${FILESDIR}/tdesktop-2.7.3-disable-webkit-separately.patch"
	# https://github.com/desktop-app/lib_webview/commit/0b4100d7cecc4e748c51f3f51ebfd1392ec3978a
	"${FILESDIR}/tdesktop-2.7.3-webview-include-gdkx.patch"
	# https://github.com/desktop-app/lib_webview/pull/3
	"${FILESDIR}/tdesktop-2.7.4-webview-fix-gcc11.patch"
	# https://github.com/telegramdesktop/tdesktop/issues/16217
	"${FILESDIR}/tdesktop-2.7.4-voice-crash.patch"
	"${FILESDIR}/tdesktop-2.7.4-voice-ffmpeg44.patch"
	# https://github.com/telegramdesktop/tdesktop/commit/404538c98968d44d207671de3adde91b8df50721
	"${FILESDIR}/tdesktop-2.7.4-fix-disable-dbus-integration.patch"
)

pkg_pretend() {
	if has ccache ${FEATURES}; then
		ewarn
		ewarn "ccache does not work with ${PN} out of the box"
		ewarn "due to usage of precompiled headers"
		ewarn "check bug https://bugs.gentoo.org/715114 for more info"
		ewarn
	fi
}

src_prepare() {
	# no explicit toggle, doesn't build with the system one #752417
	sed -i 's/DESKTOP_APP_USE_PACKAGED/NO_ONE_WILL_EVER_SET_THIS/' \
		cmake/external/rlottie/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	# gtk is really needed for image copy-paste due to https://bugreports.qt.io/browse/QTBUG-56595
	local mycmakeargs=(
		-DTDESKTOP_LAUNCHER_BASENAME="${PN}"
		-DCMAKE_DISABLE_FIND_PACKAGE_tl-expected=ON  # header only lib, some git version. prevents warnings.

		-DDESKTOP_APP_DISABLE_X11_INTEGRATION=$(usex X OFF ON)
		-DDESKTOP_APP_DISABLE_WAYLAND_INTEGRATION=$(usex wayland OFF ON)
		-DDESKTOP_APP_DISABLE_DBUS_INTEGRATION=$(usex dbus OFF ON)
		-DDESKTOP_APP_DISABLE_GTK_INTEGRATION=$(usex gtk OFF ON)
		-DDESKTOP_APP_DISABLE_WEBKIT_INTEGRATION=$(usex webkit OFF ON)
		-DDESKTOP_APP_DISABLE_SPELLCHECK=$(usex spell OFF ON)  # enables hunspell (recommended)
		-DDESKTOP_APP_USE_ENCHANT=$(usex enchant ON OFF)  # enables enchant and disables hunspell
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
	use gtk || elog "enable 'gtk' useflag if you have image copy-paste problems"
}
