# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Web Client for Jellyfin"
HOMEPAGE="https://github.com/jellyfin/jellyfin-media-player"
SRC_URI="
	https://repo.jellyfin.org/releases/server/portable/versions/stable/web/${PV}/jellyfin-web_${PV}_portable.tar.gz
"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	app-arch/unzip
"

RDEPEND="
	!media-video/jellyfin-web-jmp-bin
"

S="${WORKDIR}/jellyfin-web_${PV}"

src_install() {
	insinto /usr/share/jellyfinmediaplayer/web-client/desktop
	doins -r .
}
