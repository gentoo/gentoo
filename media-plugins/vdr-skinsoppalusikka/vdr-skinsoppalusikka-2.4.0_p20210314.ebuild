# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

GIT_COMMIT="b3711ad70a1de85d14927e1218edc4576e338e0c"
MY_P="vdr-plugin-skinsoppalusikka-${GIT_COMMIT}"
DESCRIPTION="VDR Skin Plugin: soppalusikka"
HOMEPAGE="https://github.com/rofafor/vdr-plugin-skinsoppalusikka"
SRC_URI="https://github.com/rofafor/vdr-plugin-skinsoppalusikka/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=media-video/vdr-2.4.0:="
RDEPEND="${DEPEND}
	x11-themes/vdr-channel-logos"
BDEPEND="acct-user/vdr"

QA_FLAGS_IGNORED="
	usr/lib/vdr/plugins/libvdr-.*
	usr/lib64/vdr/plugins/libvdr-.*"

src_install() {
	vdr-plugin-2_src_install

	insinto /etc/vdr/themes
	doins "${S}"/themes/*.theme
	fowners vdr:vdr /etc/vdr -R
}
