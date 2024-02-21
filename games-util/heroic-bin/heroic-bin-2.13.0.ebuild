# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

APP_NAME="${P/-bin/}"
APP_URI="https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher"
APP_RESOURCES_COMMIT=6dfb2758e531af693f0baffa15240f152aadd68b

CHROMIUM_LANGS="
	af am ar bg bn ca cs da de el en-GB en-US es es-419 et fa fi fil fr gu he hi
	hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr sv
	sw ta te th tr uk ur vi zh-CN zh-TW
"
PYTHON_COMPAT=( python3_{10..12} )

inherit chromium-2 desktop python-single-r1 xdg

DESCRIPTION="GOG and Epic Games Launcher for Linux"
HOMEPAGE="https://heroicgameslauncher.com/
	https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/"
SRC_URI="
	${APP_URI}/releases/download/v${PV}/heroic-${PV}.tar.xz
		-> ${P}.tar.xz

	${APP_URI}/raw/${APP_RESOURCES_COMMIT}/flatpak/com.heroicgameslauncher.hgl.desktop
		-> com.heroicgameslauncher.hgl.desktop-${APP_RESOURCES_COMMIT}

	${APP_URI}/raw/${APP_RESOURCES_COMMIT}/flatpak/com.heroicgameslauncher.hgl.png
		-> com.heroicgameslauncher.hgl.png-${APP_RESOURCES_COMMIT}
"
S="${WORKDIR}/${APP_NAME}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	app-accessibility/at-spi2-core
	app-arch/brotli
	app-arch/bzip2
	dev-libs/expat
	dev-libs/fribidi
	dev-libs/glib
	dev-libs/gmp
	dev-libs/libffi
	dev-libs/libpcre2
	dev-libs/libtasn1
	dev-libs/nettle
	dev-libs/nspr
	dev-libs/nss
	dev-libs/wayland
	media-fonts/freefont
	media-gfx/graphite2
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz
	media-libs/libepoxy
	media-libs/libjpeg-turbo
	media-libs/libpng
	media-libs/mesa
	media-video/ffmpeg
	net-dns/libidn2
	net-libs/gnutls
	net-print/cups
	sys-apps/dbus
	sys-libs/glibc
	sys-libs/zlib
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libdrm
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/pixman
"

QA_PREBUILT=".*"

src_unpack() {
	unpack "${P}.tar.xz"
}

src_configure() {
	default

	chromium_suid_sandbox_check_kernel_config
}

src_prepare() {
	default

	cd locales || die
	chromium_remove_language_paks
}

src_install() {
	local app_root=/opt/${APP_NAME}
	local app_dest="${ED}"/${app_root}

	dodoc LICENSE.*
	rm LICENSE.* || die

	dodir "${app_root%/*}"
	cp -r "${S}" "${app_dest}" || die

	dosym -r "${PYTHON}"	\
		  "${app_root}"/resources/app.asar.unpacked/node_modules/register-scheme/build/node_gyp_bins/python3

	find "${app_dest}" -type f -name "*.a" -exec rm {} + || die

	dosym -r "${app_root}"/heroic /usr/bin/heroic-run

	# Install resources: desktop file and icon.
	newmenu "${DISTDIR}"/com.heroicgameslauncher.hgl.desktop-${APP_RESOURCES_COMMIT}	\
			com.heroicgameslauncher.hgl.desktop
	newicon "${DISTDIR}"/com.heroicgameslauncher.hgl.png-${APP_RESOURCES_COMMIT}	\
			com.heroicgameslauncher.hgl.png
}
