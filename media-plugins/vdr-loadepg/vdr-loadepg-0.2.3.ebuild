# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-loadepg/vdr-loadepg-0.2.3.ebuild,v 1.2 2014/01/08 14:17:39 hd_brummy Exp $

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR : Loadepg Plugin; Canal+ group (Mediahighway)"
HOMEPAGE="http://lukkinosat.altervista.org/"
SRC_URI="http://lukkinosat.altervista.org/${P}.tgz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-1.4.0"

src_prepare() {
	vdr-plugin-2_src_prepare

	sed -i loadepg.h -e 's:"../../../libsi/section.h":<vdr/libsi/section.h>:'
}

src_install() {
	vdr-plugin-2_src_install

	insinto /etc/vdr/plugins/loadepg
	doins "${S}"/conf/*
	fowners -R vdr:vdr /etc/vdr/plugins/loadepg
}
