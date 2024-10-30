# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker xdg

DESCRIPTION="A second brain, for you, forever."
HOMEPAGE="https://obsidian.md"
SRC_URI="https://github.com/obsidianmd/obsidian-releases/releases/download/v${PV}/${PN}_${PV}_amd64.deb"

S="${WORKDIR}"

LICENSE="Obsidian-EULA"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="app-accessibility/at-spi2-core:2
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/mesa
	net-print/cups
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libdrm
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/pango
"

src_prepare() {
	default

	# fix desktop file
	sed -i 's|/opt/Obsidian/obsidian|/opt/obsidian/obsidian|g' "${S}/usr/share/applications/obsidian.desktop"
}

src_install() {

	# files
	insinto /opt/obsidian
	doins -r opt/Obsidian/*

	# desktop file from deb
	domenu usr/share/applications/obsidian.desktop

	# icons from deb
	for size in 16 32 48 64 128 256 512; do
		doicon --size "${size}" "usr/share/icons/hicolor/${size}x${size}/apps/${PN}.png"
	done

	# permissions
	fperms 4755 /opt/obsidian/chrome-sandbox || die
	fperms +x  /opt/obsidian/obsidian || die

	# executable
	dosym ../../opt/obsidian/obsidian /usr/bin/obsidian

}
