# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop unpacker xdg

DESCRIPTION="IRCCloud Desktop Client"
HOMEPAGE="https://github.com/irccloud/irccloud-desktop
	https://www.irccloud.com/"
SRC_URI="https://github.com/irccloud/irccloud-desktop/releases/download/v${PV}/irccloud-desktop_${PV}_linux_amd64.deb"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror strip"

DEPEND="
	>=x11-libs/gtk+-3.0
	x11-libs/libnotify
	>=dev-libs/nss-3
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	x11-misc/xdg-utils
	net-print/cups
	>=app-accessibility/at-spi2-core-2.0.0
"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	sed -i 's/--no-sandbox//g' usr/share/applications/irccloud.desktop || die
	domenu usr/share/applications/irccloud.desktop

	for size in 16 32 48 64 128 256 512; do
		doicon -s ${size} usr/share/icons/hicolor/${size}x${size}/apps/irccloud.png
	done

	gunzip usr/share/doc/irccloud-desktop/changelog.gz || die
	dodoc usr/share/doc/irccloud-desktop/changelog

	insinto /
	doins -r opt
	fperms +x /opt/IRCCloud/irccloud
	dosym ../IRCCloud/irccloud /opt/bin/irccloud
}
