# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# NOTICE: This is a Electron app (oh my) and the upstream only provides AppImages.

EAPI=8

APPIMAGE="Joplin-${PV}.AppImage"

inherit desktop xdg

DESCRIPTION="Secure note taking and to-do app with synchronization capabilities"
HOMEPAGE="https://joplinapp.org/
	https://github.com/laurent22/joplin/"
SRC_URI="https://github.com/laurent22/joplin/releases/download/v${PV}/${APPIMAGE}"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist"

RDEPEND="
	>=app-accessibility/at-spi2-core-2.46.0:2
	app-crypt/libsecret[crypt]
	app-misc/ca-certificates
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	|| (
		media-libs/libcanberra-gtk3
		media-libs/libcanberra[gtk3(-)]
	)
	media-libs/libglvnd
	media-libs/mesa
	net-misc/curl
	net-print/cups
	sys-apps/dbus
	sys-libs/zlib
	sys-process/lsof
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libdrm
	x11-libs/libnotify
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libxkbcommon
	x11-libs/libxkbfile
	x11-libs/libXrandr
	x11-libs/libXScrnSaver
	x11-libs/pango
	x11-misc/xdg-utils
"

QA_PREBUILT="*"

src_unpack() {
	mkdir -p "${S}" || die
	cp "${DISTDIR}/${APPIMAGE}" "${S}" || die

	cd "${S}" || die         # "appimage-extract" unpacks to current directory.
	chmod +x "${S}/${APPIMAGE}" || die
	"${S}/${APPIMAGE}" --appimage-extract || die
}

src_prepare() {
	# Fix permissions.
	find "${S}" -type d -exec chmod a+rx {} + || die
	find "${S}" -type f -exec chmod a+r {} + || die

	default
}

src_install() {
	cd "${S}/squashfs-root" || die

	insinto /usr/share
	doins -r ./usr/share/icons

	local apphome="/opt/${PN}"
	local toremove=(
		.DirIcon
		@joplinapp-desktop.desktop
		@joplinapp-desktop.png
		AppRun
		LICENSE.electron.txt
		LICENSES.chromium.html
		resources/app.asar.unpacked/node_modules/7zip-bin-linux/arm
		resources/app.asar.unpacked/node_modules/7zip-bin-linux/arm64
		resources/app.asar.unpacked/node_modules/node-notifier
		usr
	)
	rm -f -r "${toremove[@]}" || die

	mkdir -p "${ED}/${apphome}" || die
	cp -r . "${ED}/${apphome}" || die

	dosym -r "${apphome}/@joplinapp-desktop" "/usr/bin/${PN}"
	make_desktop_entry "${PN}" Joplin @joplinapp-desktop "Office;" \
		"StartupWMClass=Joplin\nMimeType=x-scheme-handler/joplin;"
}
