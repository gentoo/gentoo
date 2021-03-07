# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: Scan for channels on DVB-? and on PVR*-Cards"
HOMEPAGE="https://github.com/CvH/vdr-plugin-wirbelscan"
SRC_URI="http://wirbel.htpc-forum.de/wirbelscan/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=media-video/vdr-2"

src_prepare() {
	# remove untranslated po files
	rm "${S}"/po/{ca_ES,cs_CZ,da_DK,es_ES,el_GR,et_EE,fi_FI,fr_FR,hr_HR,hu_HU,nl_NL,nn_NO,pl_PL,pt_PT,ro_RO,ru_RU,sl_SI,sv_SE,tr_TR}.po

	# new Makefile handling
	cp "${FILESDIR}/wirbelscan.mk" "${S}/Makefile"

	eapply "${FILESDIR}/receiver-api-fixes.patch"

	vdr-plugin-2_src_prepare

	fix_vdr_libsi_include scanfilter.h
	fix_vdr_libsi_include scanfilter.c
	fix_vdr_libsi_include caDescriptor.h
}
