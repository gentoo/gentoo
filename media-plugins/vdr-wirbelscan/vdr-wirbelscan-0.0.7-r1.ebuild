# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-wirbelscan/vdr-wirbelscan-0.0.7-r1.ebuild,v 1.1 2014/01/06 14:52:20 hd_brummy Exp $

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: Scan for channels on DVB-? and on PVR*-Cards"
HOMEPAGE="http://wirbel.htpc-forum.de/wirbelscan/index2.html"
SRC_URI="http://wirbel.htpc-forum.de/wirbelscan/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-2"
RDEPEND="${DEPEND}"

src_prepare() {
	# remove untranslated po files
	rm "${S}"/po/{ca_ES,cs_CZ,da_DK,es_ES,el_GR,et_EE,fi_FI,fr_FR,hr_HR,hu_HU,nl_NL,nn_NO,pl_PL,pt_PT,ro_RO,ru_RU,sl_SI,sv_SE,tr_TR}.po

	# new Makefile handling
	cp "${FILESDIR}/wirbelscan.mk" "${S}/Makefile"

	epatch "${FILESDIR}/receiver-api-fixes.patch"

	vdr-plugin-2_src_prepare

	fix_vdr_libsi_include scanfilter.h
	fix_vdr_libsi_include scanfilter.c
	fix_vdr_libsi_include caDescriptor.h
}
