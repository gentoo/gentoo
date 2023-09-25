# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Modified Jellyfin Web Client for use inside Jellyfin Media Player"
HOMEPAGE="https://github.com/jellyfin/jellyfin-media-player"
SRC_URI="
	https://github.com/iwalton3/${PN%-bin}/releases/download/jwc-${PV}/dist.zip -> ${P}.zip
"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	app-arch/unzip
"

S="${WORKDIR}/dist"

src_install() {
	insinto /usr/share/jellyfinmediaplayer/web-client/desktop
	doins -r .
}
