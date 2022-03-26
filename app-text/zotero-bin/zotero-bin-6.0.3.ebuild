# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="Helps you collect, organize, cite, and share your research sources"
HOMEPAGE="https://www.zotero.org"
SRC_URI="https://www.zotero.org/download/client/dl?channel=release&platform=linux-x86_64&version=${PV} -> ${P}.tar.bz2"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="-* ~amd64"

RDEPEND="
	dev-libs/atk
	dev-libs/dbus-glib
	dev-libs/glib
	dev-libs/nspr
	dev-libs/nss
	media-libs/fontconfig
	media-libs/freetype
	sys-apps/dbus
	sys-libs/glibc
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrender
	x11-libs/libXt
	x11-libs/pango
"

S="${WORKDIR}/Zotero_linux-x86_64"

QA_PREBUILT="opt/zotero/*"

src_prepare() {
	# disable auto-update
	sed -i -e 's/\(pref("app.update.enabled"\).*/\1, false);/' defaults/preferences/prefs.js || die

	# disable default oo installation questions - manual installation is still possible
	sed -i -e 's/\(pref("extensions.zoteroOpenOfficeIntegration.skipInstallation"\).*/\1, true);/' \
		extensions/zoteroOpenOfficeIntegration@zotero.org/defaults/preferences/zoteroOpenOfficeIntegration.js || die

	# fix desktop-file
	sed -i -e 's#^Exec=.*#Exec=zotero#' zotero.desktop || die
	sed -i -e 's#Icon=zotero.*#Icon=zotero#' zotero.desktop || die

	default
}

src_install() {
	dodir opt/zotero
	cp -a "${S}"/* "${ED}/opt/zotero" || die

	dosym ../../opt/zotero/zotero usr/bin/zotero

	domenu zotero.desktop

	for size in 16 32 48 256; do
		newicon -s ${size} chrome/icons/default/default${size}.png zotero.png
	done
}
