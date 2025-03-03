# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: RSS reader"
HOMEPAGE="https://github.com/rofafor/vdr-plugin-rssreader"
SRC_URI="https://github.com/rofafor/vdr-plugin-rssreader/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vdr-plugin-rssreader-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>media-video/vdr-2.4
	dev-libs/expat
	net-misc/curl"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-2.0.0-gentoo.diff"
)
QA_FLAGS_IGNORED="
	usr/lib/vdr/plugins/libvdr-rssreader.*
	usr/lib64/vdr/plugins/libvdr-rssreader.*"

src_install() {
	vdr-plugin-2_src_install

	insinto /etc/vdr/plugins/rssreader
	doins "${S}/rssreader/rssreader.conf"
}
