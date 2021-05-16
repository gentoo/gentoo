# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

MY_P="v2.4.0"

DESCRIPTION="VDR Plugin: RSS reader"
HOMEPAGE="https://github.com/rofafor/vdr-plugin-rssreader"
SRC_URI="https://github.com/rofafor/vdr-plugin-rssreader/archive/refs/tags/${MY_P}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-2.4.0
		>=dev-libs/expat-1.95.8
		>=net-misc/curl-7.15.1-r1"

RDEPEND="${DEPEND}"

S="${WORKDIR}/vdr-plugin-rssreader-${PV}"

src_install() {
	vdr-plugin-2_src_install

	insinto /etc/vdr/plugins/rssreader
	doins "${S}/rssreader/rssreader.conf"
}
