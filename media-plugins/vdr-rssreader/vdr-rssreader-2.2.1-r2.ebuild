# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: RSS reader"
HOMEPAGE="https://github.com/rofafor/vdr-plugin-rssreader"
SRC_URI="https://github.com/rofafor/vdr-plugin-rssreader/archive/v${PV}.tar.gz -> ${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=media-video/vdr-2.2.0
	>=dev-libs/expat-1.95.8
	>=net-misc/curl-7.15.1-r1"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-2.0.0-gentoo.diff"
	"${FILESDIR}/${P}_c++11.patch"
)
QA_FLAGS_IGNORED="
	usr/lib/vdr/plugins/libvdr-rssreader.*
	usr/lib64/vdr/plugins/libvdr-rssreader.*"

src_install() {
	vdr-plugin-2_src_install

	insinto /etc/vdr/plugins/rssreader
	doins "${S}/rssreader/rssreader.conf"
}
