# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR Skin Plugin: soppalusikka"
HOMEPAGE="https://github.com/rofafor/vdr-plugin-skinsoppalusikka"
SRC_URI="https://github.com/rofafor/vdr-plugin-skinsoppalusikka/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=">=media-video/vdr-2.4.0"
RDEPEND="${DEPEND}
	x11-themes/vdr-channel-logos"

QA_FLAGS_IGNORED="
	usr/lib/vdr/plugins/libvdr-.*
	usr/lib64/vdr/plugins/libvdr-.*"
S="${WORKDIR}/vdr-plugin-skinsoppalusikka-${PV}"

src_install() {
	vdr-plugin-2_src_install

	insinto /etc/vdr/themes
	doins "${S}"/themes/*.theme
	fowners vdr:vdr /etc/vdr -R
}
