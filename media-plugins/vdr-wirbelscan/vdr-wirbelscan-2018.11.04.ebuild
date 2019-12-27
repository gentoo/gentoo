# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

GIT_VERSION="e1377b95312a138a41f93d7b06b3adb4ed4e7324"

DESCRIPTION="VDR Plugin: Scan for channels on DVB-? and on PVR*-Cards"
HOMEPAGE="https://github.com/CvH/vdr-plugin-wirbelscan"
SRC_URI="https://github.com/CvH/vdr-plugin-wirbelscan/archive/${GIT_VERSION}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=media-video/vdr-2.4"

S="${WORKDIR}/vdr-plugin-wirbelscan-${GIT_VERSION}"

src_prepare() {
	# remove untranslated po files
	rm "${S}"/po/{ca_ES,cs_CZ,da_DK,es_ES,el_GR,et_EE,fi_FI,fr_FR,hr_HR,hu_HU,nl_NL,nn_NO,pl_PL,pt_PT,ro_RO,ru_RU,sl_SI,sv_SE,tr_TR}.po

	vdr-plugin-2_src_prepare

	fix_vdr_libsi_include scanfilter.h
	fix_vdr_libsi_include scanfilter.c
}
