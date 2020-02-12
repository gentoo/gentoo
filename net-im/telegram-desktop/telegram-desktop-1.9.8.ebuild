# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit cmake desktop flag-o-matic python-any-r1 xdg-utils

MY_P="tdesktop-${PV}-full"

DESCRIPTION="Official desktop client for Telegram"
HOMEPAGE="https://desktop.telegram.org"
SRC_URI="https://github.com/telegramdesktop/tdesktop/releases/download/v${PV}/${MY_P}.tar.gz"

LICENSE="GPL-3-with-openssl-exception Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE="dbus gtk3 libressl spell"

RDEPEND="!net-im/telegram-desktop-bin
	app-arch/lz4
	app-arch/xz-utils
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	dev-cpp/range-v3
	dev-libs/xxhash
	dev-qt/qtcore:5
	dev-qt/qtgui:5[png,X(-)]
	dev-qt/qtimageformats:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5[png,X(-)]
	media-libs/openal[pulseaudio]
	media-libs/opus
	media-sound/pulseaudio
	sys-libs/zlib[minizip]
	virtual/ffmpeg
	x11-libs/libva[X,drm]
	x11-libs/libX11
	dbus? ( dev-qt/qtdbus:5 )
	gtk3? (
		dev-libs/libappindicator:3
		x11-libs/gtk+:3
	)
	spell? ( app-text/enchant:= )
"

DEPEND="${RDEPEND}
	${PYTHON_DEPS}"

BDEPEND="
	>=dev-util/cmake-3.16
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/0002-PPC-big-endian.patch"
	"${FILESDIR}/0003-PPC-config.patch"
	"${FILESDIR}/musl.patch"
)

S="${WORKDIR}/${MY_P}"

src_configure() {
	local mycxxflags=(
		-Wno-deprecated-declarations
		-Wno-error=deprecated-declarations
		-Wno-switch
	)

	append-cxxflags "${mycxxflags[@]}"

	local mycmakeargs=(
		-Ddisable_autoupdate=1
		-DDESKTOP_APP_DISABLE_CRASH_REPORTS=ON
		-DDESKTOP_APP_USE_GLIBC_WRAPS=OFF
		-DDESKTOP_APP_USE_PACKAGED=ON
		-DDESKTOP_APP_USE_PACKAGED_RLOTTIE=OFF
		-DTDESKTOP_DISABLE_DESKTOP_FILE_GENERATION=ON
		-DTDESKTOP_LAUNCHER_BASENAME="${PN}"
		-DTDESKTOP_USE_PACKAGED_TGVOIP=OFF
		-DDESKTOP_APP_DISABLE_SPELLCHECK="$(usex spell OFF ON)"
		-DTDESKTOP_DISABLE_GTK_INTEGRATION="$(usex gtk3 OFF ON)"
		-DTDESKTOP_DISABLE_DBUS_INTEGRATION="$(usex dbus OFF ON)"
		-DTDESKTOP_FORCE_GTK_FILE_DIALOG="$(usex gtk3)"
	)

	if [[ -n ${MY_TDESKTOP_API_ID} && -n ${MY_TDESKTOP_API_HASH} ]]; then
		einfo "Found custom API credentials"
		mycmakeargs+=(
			-DTDESKTOP_API_ID="${MY_TDESKTOP_API_ID}"
			-DTDESKTOP_API_HASH="${MY_TDESKTOP_API_HASH}"
		)
	else
		mycmakeargs+=( -DTDESKTOP_API_TEST=ON )
		ewarn
		ewarn "Building ${PN} with test API credentials."
		ewarn "Connectivity to API servers will be throttled."
		ewarn "To build ${PN} custom API credentials cancel build now and obtain"
		ewarn "credentials here: https://github.com/telegramdesktop/tdesktop/blob/dev/docs/api_credentials.md"
		ewarn "After getting credentials you can export variables:"
		ewarn "export MY_TDESKTOP_API_ID=\"17349\""
		ewarn "export MY_TDESKTOP_API_HASH=\"344583e45741c457fe1862106095a5eb\""
		ewarn "and restart the build"
		ewarn "you can save variables in /etc/portage/env/${CATEGORY}/${PN}"
		ewarn "portage will use the file every build automatically"
		ewarn
	fi

	cmake_src_configure
}

src_install() {
	dobin "${BUILD_DIR}/bin/${PN}"

	newmenu lib/xdg/telegramdesktop.desktop "${PN}.desktop"

	local icon_size
	for icon_size in 16 32 48 64 128 256 512
	do
		newicon -s ${icon_size} \
			Telegram/Resources/art/icon${icon_size}.png telegram.png
	done

	insinto /usr/share/appdata
	doins lib/xdg/telegramdesktop.appdata.xml

	insinto /usr/share/kservices5
	doins lib/xdg/tg.protocol

	einstalldocs
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
