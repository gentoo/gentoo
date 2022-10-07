# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit xdg cmake python-any-r1 optfeature

DESCRIPTION="Official desktop client for Telegram"
HOMEPAGE="https://desktop.telegram.org"

MY_P="tdesktop-${PV}-full"
SRC_URI="https://github.com/telegramdesktop/tdesktop/releases/download/v${PV}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD GPL-3-with-openssl-exception LGPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv"
IUSE="+dbus enchant +hunspell +jemalloc screencast +spell wayland +X"
REQUIRED_USE="
	spell? (
		^^ ( enchant hunspell )
	)
"

RDEPEND="
	!net-im/telegram-desktop-bin
	app-arch/lz4:=
	dev-cpp/abseil-cpp:=
	dev-libs/libdispatch
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
	~media-libs/libtgvoip-2.4.4_p20220117
	media-libs/openal
	media-libs/opus:=
	media-libs/rnnoise
	~media-libs/tg_owt-0_pre20220209[screencast=,X=]
	media-video/ffmpeg:=[opus]
	sys-libs/zlib:=[minizip]
	dbus? (
		dev-cpp/glibmm:2
		dev-qt/qtdbus:5
		dev-libs/libdbusmenu-qt[qt5(+)]
	)
	enchant? ( app-text/enchant:= )
	hunspell? ( >=app-text/hunspell-1.7:= )
	jemalloc? ( dev-libs/jemalloc:=[-lazy-lock] )
	wayland? (
		dev-qt/qtwayland:=
		kde-frameworks/kwayland:=
	)
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

PATCHES=(
	"${FILESDIR}/tdesktop-3.6.0-jemalloc-only-telegram.patch"
	"${FILESDIR}/tdesktop-3.3.0-fix-enchant.patch"
	"${FILESDIR}/tdesktop-3.5.2-musl.patch"
	"${FILESDIR}/tdesktop-3.6.0-support-ffmpeg5.patch"
	"${FILESDIR}/tdesktop-3.6.1-fix-kwayland-5.93.patch"
	"${FILESDIR}/tdesktop-3.6.1-fix-use-after-free.patch"
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
	local mycmakeargs=(
		-DTDESKTOP_LAUNCHER_BASENAME="${PN}"
		-DCMAKE_DISABLE_FIND_PACKAGE_tl-expected=ON  # header only lib, some git version. prevents warnings.
		-DDESKTOP_APP_QT6=OFF

		-DDESKTOP_APP_DISABLE_DBUS_INTEGRATION=$(usex !dbus)
		-DDESKTOP_APP_DISABLE_X11_INTEGRATION=$(usex !X)
		-DDESKTOP_APP_DISABLE_WAYLAND_INTEGRATION=$(usex !wayland)
		-DDESKTOP_APP_DISABLE_SPELLCHECK=$(usex !spell)  # enables hunspell (recommended)
		-DDESKTOP_APP_USE_ENCHANT=$(usex enchant)  # enables enchant and disables hunspell

		# This option is heavily discouraged by upstream.
		# See files/tdesktop-*-jemalloc-optional.patch
		-DDESKTOP_APP_DISABLE_JEMALLOC=$(usex !jemalloc)
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
		elog
	fi
	if has_version '<dev-qt/qtcore-5.15.2-r10'; then
		ewarn "Versions of dev-qt/qtcore lower than 5.15.2-r10 might cause telegram"
		ewarn "to crash when pasting big images from the clipboard."
		ewarn
	fi
	if ! use jemalloc && use elibc_glibc; then
		ewarn "Disabling USE=jemalloc on glibc systems may cause very high RAM usage!"
		ewarn "Do NOT report issues about RAM usage without enabling this flag first."
		ewarn
	fi
	optfeature_header
	optfeature "shop payment support (requires USE=dbus enabled)" net-libs/webkit-gtk:4
}
