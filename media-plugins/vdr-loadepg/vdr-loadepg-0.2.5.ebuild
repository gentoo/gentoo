# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-loadepg/vdr-loadepg-0.2.5.ebuild,v 1.1 2014/01/08 14:17:39 hd_brummy Exp $

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR : Loadepg Plugin; Canal+ group (Mediahighway)"
HOMEPAGE="http://lukkinosat.altervista.org/"
SRC_URI="http://lukkinosat.altervista.org/${P}.tgz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-2"

src_prepare() {
	# remove untranslated po files
	rm "${S}/po/{ca_ES,cs_CZ,da_DK,el_GR,et_EE,fr_FR,hr_HR,hu_HU,nn_NO,pl_PL,pt_PT,ro_RO,ru_RU,sl_SI,sv_SE,tr_TR}.po"

	vdr-plugin-2_src_prepare

	fix_vdr_libsi_include loadepg.h
}

src_install() {
	vdr-plugin-2_src_install

	insinto /etc/vdr/plugins/loadepg
	doins "${S}"/conf/*
	fowners -R vdr:vdr /etc/vdr/plugins/loadepg
}
