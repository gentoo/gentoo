# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

inherit xdg cmake python-any-r1

DESCRIPTION="Official desktop client for Telegram"
HOMEPAGE="https://desktop.telegram.org"

MY_P="tdesktop-${PV}-full"
SRC_URI="https://github.com/telegramdesktop/tdesktop/releases/download/v${PV}/${MY_P}.tar.gz"

LICENSE="BSD GPL-3-with-openssl-exception LGPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc64"
IUSE="+dbus enchant +hunspell screencast +spell wayland webkit +X"
REQUIRED_USE="
	spell? (
		^^ ( enchant hunspell )
	)
	webkit? ( dbus )
"

RDEPEND="
	!net-im/telegram-desktop-bin
	app-arch/lz4:=
	dev-cpp/abseil-cpp:=
	dev-libs/jemalloc:=[-lazy-lock]
	dev-libs/openssl:=
	dev-libs/xxhash
	>=dev-qt/qtcore-5.15:5
	>=dev-qt/qtgui-5.15:5[dbus?,jpeg,png,wayland?,X?]
	>=dev-qt/qtimageformats-5.15:5
	>=dev-qt/qtnetwork-5.15:5[ssl]
	>=dev-qt/qtsvg-5.15:5
	>=dev-qt/qtwidgets-5.15:5[png,X?]
	media-fonts/open-sans
	media-libs/fontconfig:=
	~media-libs/libtgvoip-2.4.4_p20210302
	>=media-libs/libtgvoip-2.4.4_p20210302-r2
	media-libs/openal
	media-libs/opus:=
	media-libs/rnnoise
	~media-libs/tg_owt-0_pre20210914[screencast=,X=]
	media-video/ffmpeg:=[opus]
	sys-libs/zlib:=[minizip]
	dbus? (
		dev-cpp/glibmm:2
		dev-qt/qtdbus:5
		dev-libs/libdbusmenu-qt[qt5(+)]
	)
	enchant? ( app-text/enchant:= )
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
# dev-libs/jemalloc:=[-lazy-lock] -> https://bugs.gentoo.org/803233

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/tdesktop-3.1.0-jemalloc-only-telegram.patch"
	"${FILESDIR}/tdesktop-3.1.0-fix-openssl3.patch"
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

		-DDESKTOP_APP_DISABLE_X11_INTEGRATION=$(usex X no yes)
		-DDESKTOP_APP_DISABLE_WAYLAND_INTEGRATION=$(usex wayland no yes)
		-DDESKTOP_APP_DISABLE_DBUS_INTEGRATION=$(usex dbus no yes)
		-DDESKTOP_APP_DISABLE_WEBKITGTK=$(usex webkit no yes)
		-DDESKTOP_APP_DISABLE_SPELLCHECK=$(usex spell no yes)  # enables hunspell (recommended)
		-DDESKTOP_APP_USE_ENCHANT=$(usex enchant)  # enables enchant and disables hunspell
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
		elog "both the 'X' and 'screencast' useflags are disabled, screen sharing won't work!"
	fi
	if has_version '<dev-qt/qtcore-5.15.2-r10'; then
		ewarn "Versions of dev-qt/qtcore lower than 5.15.2-r10 might cause telegram"
		ewarn "to crash when pasting big images from the clipboard."
	fi
}
