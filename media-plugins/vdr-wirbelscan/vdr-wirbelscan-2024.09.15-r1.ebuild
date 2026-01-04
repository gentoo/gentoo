# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: Scan for channels on DVB-? and on PVR*-Cards"
HOMEPAGE="https://www.gen2vdr.de/wirbel/wirbelscan/index2.html"
SRC_URI="https://www.gen2vdr.de/wirbel/wirbelscan/vdr-wirbelscan-${PV}.tgz"
S="${WORKDIR}/wirbelscan-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-libs/librepfunc:=
	>=media-video/vdr-2.4:=
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/vdr-wirbelscan_Makefile.patch" )

src_prepare() {
	# remove untranslated po files
	rm "${S}"/po/{ca_ES,cs_CZ,da_DK,el_GR,es_ES,et_EE,fi_FI,fr_FR,hr_HR,hu_HU,nl_NL,nn_NO,pl_PL,pt_PT,ro_RO,ru_RU,sl_SI,sv_SE,tr_TR}.po || die

	vdr-plugin-2_src_prepare

	fix_vdr_libsi_include scanfilter.h
	fix_vdr_libsi_include scanfilter.cpp
	fix_vdr_libsi_include si_ext.h
}
