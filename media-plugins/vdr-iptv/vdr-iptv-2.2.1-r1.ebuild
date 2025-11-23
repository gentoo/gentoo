# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: Add a logical device capable of receiving IPTV"
HOMEPAGE="https://github.com/rofafor/vdr-plugin-iptv"
SRC_URI="https://github.com/rofafor/vdr-plugin-iptv/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vdr-plugin-iptv-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=media-video/vdr-2.1.6"
RDEPEND="${DEPEND}
	net-misc/curl"

QA_FLAGS_IGNORED="
	usr/lib/vdr/plugins/libvdr-iptv.*
	usr/lib64/vdr/plugins/libvdr-iptv.*"

src_prepare() {
	vdr-plugin-2_src_prepare

	fix_vdr_libsi_include sidscanner.c

	eapply "${FILESDIR}/${P}_c++11.patch"
}
