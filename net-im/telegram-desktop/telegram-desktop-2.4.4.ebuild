# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR="ninja"
PYTHON_COMPAT=( python3_{7,8,9} )

inherit cmake desktop flag-o-matic ninja-utils python-any-r1 xdg-utils

MY_P="tdesktop-${PV}-full"
TG_OWT_COMMIT="c73a4718cbff7048373a63db32068482e5fd11ef"

DESCRIPTION="Official desktop client for Telegram"
HOMEPAGE="https://desktop.telegram.org"
SRC_URI="https://github.com/telegramdesktop/tdesktop/releases/download/v${PV}/${MY_P}.tar.gz
	webrtc? (
		https://github.com/desktop-app/tg_owt/archive/c73a4718cbff7048373a63db32068482e5fd11ef.tar.gz -> tg_owt-${TG_OWT_COMMIT}.tar.gz
	)
"

LICENSE="GPL-3-with-openssl-exception LGPL-2+ webrtc? ( BSD )"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE="+alsa +dbus enchant +gtk +hunspell libressl +pulseaudio +spell +webrtc +X"

RDEPEND="
	!net-im/telegram-desktop-bin
	app-arch/lz4:=
	app-arch/xz-utils
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	dev-libs/xxhash
	dev-qt/qtcore:5
	dev-qt/qtgui:5[dbus?,jpeg,png,wayland,X(-)?]
	dev-qt/qtimageformats:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5[png,X(-)?]
	media-fonts/open-sans
	media-libs/fontconfig:=
	~media-libs/libtgvoip-2.4.4_p20200818[alsa?,pulseaudio?]
	media-libs/openal[alsa?,pulseaudio?]
	media-libs/opus:=
	media-video/ffmpeg:=[alsa?,opus,pulseaudio?]
	sys-libs/zlib[minizip]
	virtual/libiconv
	x11-libs/libxcb:=
	dbus? (
		dev-qt/qtdbus:5
		dev-libs/libdbusmenu-qt[qt5(+)]
	)
	enchant? ( app-text/enchant:= )
	gtk? (
		dev-libs/glib:2
		x11-libs/gdk-pixbuf:2[jpeg,X?]
		x11-libs/gtk+:3[X?]
		x11-libs/libX11
	)
	hunspell? ( >=app-text/hunspell-1.7:= )
	pulseaudio? ( media-sound/pulseaudio )
	webrtc? ( media-libs/libjpeg-turbo:= )
"

DEPEND="
	${PYTHON_DEPS}
	${RDEPEND}
	dev-cpp/range-v3
	=dev-cpp/ms-gsl-3*
"

BDEPEND="
	>=dev-util/cmake-3.16
	virtual/pkgconfig
	webrtc? ( amd64? ( dev-lang/yasm ) )
"

REQUIRED_USE="
	|| ( alsa pulseaudio )
	spell? (
		^^ ( enchant hunspell )
	)
	webrtc? ( alsa pulseaudio )
"

S="${WORKDIR}/${MY_P}"

pkg_pretend() {
	if has ccache ${FEATURES}; then
		ewarn
		ewarn "ccache does not work with ${PN} out of the box"
		ewarn "due to usage of precompiled headers"
		ewarn "check bug https://bugs.gentoo.org/715114 for more info"
		ewarn
	fi
}

src_unpack() {
	default
	use webrtc && mv -v "${WORKDIR}/tg_owt-${TG_OWT_COMMIT}" "${WORKDIR}/tg_owt"
}

build_tg_owt() {
	einfo "Building tg_owt / webrtc"
	mkdir -v "${WORKDIR}/tg_owt_build" || die
	pushd "${WORKDIR}/tg_owt_build" > /dev/null || die
	cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DTG_OWT_PACKAGED_BUILD=ON ../tg_owt || die
	eninja
	popd > /dev/null || die
}

src_configure() {
	local mycxxflags=(
		-Wno-deprecated-declarations
		-Wno-error=deprecated-declarations
		-Wno-switch
	)

	append-cxxflags "${mycxxflags[@]}"

	# we have to build tg_owt now before running telegram's cmake
	use webrtc && build_tg_owt

	# TODO: unbundle header-only libs, ofc telegram uses git versions...
	# it fals with tl-expected-1.0.0, so we use bundled for now to avoid git rev snapshots
	# EXPECTED VARIANT
	# gtk is really needed for image copy-paste due to https://bugreports.qt.io/browse/QTBUG-56595
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_rlottie=ON # it does not build with system one, prevent automagic.
		-DCMAKE_DISABLE_FIND_PACKAGE_tl-expected=ON # header only lib, some git version. prevents warnings.
		-DDESKTOP_APP_DISABLE_CRASH_REPORTS=ON
		-DDESKTOP_APP_USE_GLIBC_WRAPS=OFF
		-DDESKTOP_APP_USE_PACKAGED=ON
		-DDESKTOP_APP_USE_PACKAGED_FONTS=ON
		-DTDESKTOP_DISABLE_GTK_INTEGRATION="$(usex gtk OFF ON)"
		-DTDESKTOP_LAUNCHER_BASENAME="${PN}"
		-DDESKTOP_APP_DISABLE_DBUS_INTEGRATION="$(usex dbus OFF ON)"
		-DDESKTOP_APP_DISABLE_SPELLCHECK="$(usex spell OFF ON)" # enables hunspell (recommended)
		-DDESKTOP_APP_DISABLE_WEBRTC_INTEGRATION="$(usex webrtc OFF ON)" # requires pulse AND alsa
		-DDESKTOP_APP_USE_ENCHANT="$(usex enchant ON OFF)" # enables enchant and disables hunspell
		$(usex webrtc "-Dtg_owt_DIR=${WORKDIR}/tg_owt_build" '')
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
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	use gtk || einfo "enable 'gtk' useflag if you have image copy-paste problems"
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
