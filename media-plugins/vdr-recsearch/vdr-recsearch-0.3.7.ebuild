# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: Search through your recordings and find the one you are looking for"
HOMEPAGE="https://github.com/flensrocker/vdr-plugin-recsearch"
SRC_URI="https://github.com/flensrocker/vdr-plugin-recsearch/releases/download/v${PV}/${P}.tgz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND="media-video/vdr"

S="${WORKDIR}/recsearch-${PV}"

src_install() {
	vdr-plugin-2_src_install

	touch last.conf
	touch searches.conf
	insopts -m0644 -ovdr -gvdr
	insinto /etc/vdr/plugins/${VDRPLUGIN}
	doins last.conf searches.conf
}
