# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHROMIUM_LANGS="
	af am ar bg bn ca cs da de el en-GB en-US es es-419 et fa fi fil fr gu he hi
	hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr sv
	sw ta te th tr uk ur vi zh-CN zh-TW
"
PYTHON_COMPAT=( python3_{11..14} python3_13t )

inherit chromium-2 desktop python-single-r1 xdg

DESCRIPTION="GOG and Epic Games Launcher for Linux"
HOMEPAGE="https://heroicgameslauncher.com/
	https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/"
SRC_URI="
	https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/releases/download/v${PV}/heroic-${PV}-linux-x64.tar.xz
		-> ${P}.tar.xz
	https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/raw/v${PV}/flatpak/com.heroicgameslauncher.hgl.desktop
		-> com.heroicgameslauncher.hgl.${PV}.desktop
	https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/raw/v${PV}/flatpak/com.heroicgameslauncher.hgl.png
		-> com.heroicgameslauncher.hgl.${PV}.png
"
S="${WORKDIR}/Heroic-${PV}-linux-x64"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gamescope"
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
	virtual/zlib:=
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
	gamescope? ( gui-wm/gamescope )
"

QA_PREBUILT=".*"

src_configure() {
	default

	chromium_suid_sandbox_check_kernel_config
}

src_prepare() {
	default

	cd locales || die
	chromium_remove_language_paks

	# Create gamescope desktop file
	if use gamescope; then
		cp "${DISTDIR}"/com.heroicgameslauncher.hgl.${PV}.desktop \
			"${WORKDIR}"/com.heroicgameslauncher.hgl.gamescope.${PV}.desktop || die

		sed -i 's/Name=Heroic Games Launcher/Name=Heroic Games Launcher (Gamescope)/g' \
			"${WORKDIR}"/com.heroicgameslauncher.hgl.gamescope.${PV}.desktop || die
		sed -i 's/Exec=heroic-run %u/Exec=env GDK_BACKEND=wayland gamescope -f -R --RT --force-grab-cursor --prefer-vk-device --adaptive-sync --nested-unfocused-refresh 30 -- heroic-run --ozone-platform=x11 --enable-features=UseOzonePlatform,WaylandWindowDecorations/g' \
			"${WORKDIR}"/com.heroicgameslauncher.hgl.gamescope.${PV}.desktop || die
	fi
}

src_install() {
	local app_root=/opt/${P/-bin}
	local app_dest="${ED}"/${app_root}

	dodoc LICENSE.*
	rm LICENSE.* || die

	dodir "${app_root%/*}"
	cp -r "${S}" "${app_dest}" || die

	dosym -r "${PYTHON}" \
		"${app_root}"/resources/app.asar.unpacked/node_modules/register-scheme/build/node_gyp_bins/python3

	find "${app_dest}" -type f -name "*.a" -exec rm {} + || die

	dosym -r "${app_root}"/heroic /usr/bin/heroic-run

	# Install resources: desktop file and icon.
	newmenu "${DISTDIR}"/com.heroicgameslauncher.hgl.${PV}.desktop \
			com.heroicgameslauncher.hgl.desktop
	if use gamescope; then
		newmenu "${WORKDIR}"/com.heroicgameslauncher.hgl.gamescope.${PV}.desktop \
			com.heroicgameslauncher.hgl.gamescope.desktop
	fi
	newicon "${DISTDIR}"/com.heroicgameslauncher.hgl.${PV}.png	\
			com.heroicgameslauncher.hgl.png
}
