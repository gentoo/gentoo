# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: Load EPG from file or MediaHighWay or SkyBox Receivers"
HOMEPAGE="https://lukkinosat.altervista.org/"
SRC_URI="https://lukkinosat.altervista.org/${P}.tgz"
S="${WORKDIR}/${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-video/vdr"
RDEPEND="${DEPEND}"
BDEPEND="acct-user/vdr"

PATCHES=( "${FILESDIR}/${P}_asprintf.patch" )

src_prepare() {
	# remove untranslated po files
	rm "${S}"/po/{ca_ES,cs_CZ,da_DK,el_GR,et_EE,fr_FR,hr_HR,hu_HU,nn_NO,pl_PL,pt_PT,ro_RO,ru_RU,sl_SI,sv_SE,tr_TR}.po \
		|| die

	vdr-plugin-2_src_prepare

	fix_vdr_libsi_include loadepg.h
}

src_install() {
	vdr-plugin-2_src_install

	insinto /etc/vdr/plugins/loadepg
	doins "${S}"/conf/*
	fowners -R vdr:vdr /etc/vdr/plugins/loadepg
}
