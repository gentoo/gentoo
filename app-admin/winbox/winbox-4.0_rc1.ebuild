# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="Management Software for MikroTik RouterOS"
HOMEPAGE="https://mikrotik.com/"
SRC_URI="https://download.mikrotik.com/routeros/winbox/$(ver_cut 1-2)$(ver_cut 3-4)/WinBox_Linux.zip -> ${P}.zip"
S="${WORKDIR}"

LICENSE="MikroTik"
SLOT="0"
KEYWORDS="-* ~amd64"

RDEPEND="
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libglvnd
	virtual/zlib:=
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/xcb-util-image
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-renderutil
	x11-libs/xcb-util-wm
"
BDEPEND="app-arch/unzip"

RESTRICT="bindist mirror"

QA_PREBUILT="opt/winbox/WinBox"

src_install() {
	exeinto /opt/winbox
	doexe WinBox

	insinto /opt/winbox
	doins -r assets

	dodir /opt/bin
	dosym ../winbox/WinBox /opt/bin/winbox

	doicon assets/img/winbox.png
	make_desktop_entry winbox WinBox winbox Network
}
