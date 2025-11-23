# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: Search through your recordings and find the one you are looking for"
HOMEPAGE="https://github.com/flensrocker/vdr-plugin-recsearch"
SRC_URI="https://github.com/flensrocker/vdr-plugin-recsearch/releases/download/v${PV}/${P}.tgz"
S="${WORKDIR}/recsearch-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-video/vdr"
BDEPEND="${DEPEND}"
RDEPEND="acct-user/vdr"

src_install() {
	vdr-plugin-2_src_install

	touch last.conf
	touch searches.conf
	insopts -m0644 -ovdr -gvdr
	insinto /etc/vdr/plugins/${VDRPLUGIN}
	doins last.conf searches.conf
}
