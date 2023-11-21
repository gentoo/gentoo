# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit user-info vdr-plugin-2

VERSION="2084" # every bump, new version

DESCRIPTION="VDR Plugin: to play dvds and dvd file structures"
HOMEPAGE="https://projects.vdr-developer.org/projects/plg-dvdswitch"
SRC_URI="https://projects.vdr-developer.org/attachments/download/${VERSION}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="acct-user/vdr"
DEPEND="${BDEPEBD}
	media-video/vdr"
RDEPEND="${DEPEND}
	media-plugins/vdr-dvd"

QA_FLAGS_IGNORED="
	usr/lib/vdr/plugins/libvdr-.*
	usr/lib64/vdr/plugins/libvdr-.*"

src_prepare() {
	vdr-plugin-2_src_prepare

	local vdr_user_home=$(egethome vdr)
	sed -e "s:/video/dvd:${vdr_user_home}/video/dvd-images:" -i setup.c || die
}
