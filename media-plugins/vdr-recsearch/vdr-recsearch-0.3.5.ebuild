# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: Search through your recordings and find the one you are looking for..."
HOMEPAGE="https://github.com/flensrocker/vdr-plugin-recsearch"
SRC_URI="https://github.com/flensrocker/vdr-plugin-recsearch/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-2.0.4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/vdr-plugin-recsearch-${PV}"

src_install() {
	vdr-plugin-2_src_install

	touch last.conf
	touch searches.conf
	insopts -m0644 -ovdr -gvdr
	insinto /etc/vdr/plugins/${VDRPLUGIN}
	doins last.conf searches.conf
}
