# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR : Loadepg Plugin; Canal+ group (Mediahighway)"
HOMEPAGE="http://lukkinosat.altervista.org/"
SRC_URI="http://lukkinosat.altervista.org/${P}.tgz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="media-video/vdr"

src_prepare() {
	# remove untranslated po files
	rm "${S}/po/{ca_ES,cs_CZ,da_DK,el_GR,et_EE,fr_FR,hr_HR,hu_HU,nn_NO,pl_PL,pt_PT,ro_RO,ru_RU,sl_SI,sv_SE,tr_TR}.po"

	vdr-plugin-2_src_prepare

	fix_vdr_libsi_include loadepg.h

	eapply "${FILESDIR}/${P}_asprintf.patch"
}

src_install() {
	vdr-plugin-2_src_install

	insinto /etc/vdr/plugins/loadepg
	doins "${S}"/conf/*
	fowners -R vdr:vdr /etc/vdr/plugins/loadepg
}
