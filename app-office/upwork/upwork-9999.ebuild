# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop pax-utils rpm xdg-utils

DESCRIPTION="Project collaboration and tracking software for upwork.com"
HOMEPAGE="https://www.upwork.com/"
LICENSE="ODESK"
PROPERTIES+=" live"  # because otherwise you have to download it manually
SLOT="0"
RESTRICT="bindist mirror"
KEYWORDS="amd64 x86"  # upwork ships it as a stable version

RDEPEND="
	dev-libs/expat
	dev-libs/nspr
	dev-libs/nss
	gnome-base/gconf
	media-libs/alsa-lib
	media-libs/freetype
	sys-apps/dbus
	sys-libs/libcap
	x11-libs/gtk+:3[cups]
	x11-libs/libXinerama
	x11-libs/libXScrnSaver
	x11-libs/libXtst
"

S="${WORKDIR}"

PATCHES=( "${FILESDIR}/${PN}-desktop-r2.patch" )

# Binary only distribution
QA_PREBUILT="*"

src_unpack() {
	# mimic AUR package: https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=upwork#n19
	use amd64 && pkg_uri="https://upwork-usw2-desktopapp.upwork.com/binaries/v5_8_0_24_aef0dc8c37cf46a8/upwork-5.8.0.24-1fc24.x86_64.rpm"
	use x86   && pkg_uri="https://upwork-usw2-desktopapp.upwork.com/binaries/v5_8_0_24_aef0dc8c37cf46a8/upwork-5.8.0.24-1fc24.i386.rpm"

	header="--header=User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:104.0) Gecko/20100101 Firefox/104.0"
	pkg_binary="upwork.rpm"
	wget "$header" "$pkg_uri" -O "$WORKDIR/$pkg_binary"

	rpm_unpack "./$pkg_binary"
}

src_install() {
	pax-mark m opt/Upwork/upwork

	mv opt "$ED"

	insinto /usr/share
	doins -r usr/share/icons

	domenu usr/share/applications/upwork.desktop
	doicon usr/share/icons/hicolor/128x128/apps/upwork.png
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
