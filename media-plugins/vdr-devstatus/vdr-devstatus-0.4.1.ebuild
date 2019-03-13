# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: display the usa status of the available DVB devices"
HOMEPAGE="http://www.u32.de/vdr.html"
SRC_URI="http://www.u32.de/download/${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-1.6.0"
RDEPEND="${DEPEND}"

src_prepare() {
	# remove untranslated .po files
	rm "${S}"/po/{ca_ES,cs_CZ,da_DK,el_GR,et_EE,hr_HR,hu_HU,nl_NL,nn_NO,pl_PL,pt_PT,ro_RO,sl_SI,sv_SE,tr_TR}.po

	vdr-plugin-2_src_prepare

	if has_version ">=media-video/vdr-1.7.28"; then
		sed -i "s:SetRecording(\([^,]*\),[^)]*)):SetRecording(\1\):" devstatus.c
	fi
}
