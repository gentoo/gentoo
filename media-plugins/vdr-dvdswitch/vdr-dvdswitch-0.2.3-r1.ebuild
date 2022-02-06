# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit user-info vdr-plugin-2

DESCRIPTION="VDR Plugin: to play dvds and dvd file structures"
HOMEPAGE="https://github.com/vdr-projects/vdr-plugin-dvdswitch"
SRC_URI="https://github.com/vdr-projects/vdr-plugin-dvdswitch/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vdr-plugin-dvdswitch-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="acct-user/vdr
	media-video/vdr"
DEPEND="${BDEPEND}"
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
