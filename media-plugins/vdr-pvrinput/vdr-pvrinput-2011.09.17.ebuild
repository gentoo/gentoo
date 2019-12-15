# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: Use a PVR* card as input device"
HOMEPAGE="https://projects.vdr-developer.org/projects/plg-pvrinput"
SRC_URI="mirror://gentoo/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-1.6.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/vdr-plugin-pvrinput-3ee6b964382f38715f4a4fe57bd4760044f9a58a"

src_prepare() {
	# remove untranslated po files, i18n fix
	rm "${S}"/po2i18n.pl "${S}"/po/{i18n-template.c,i18n.h} \
	"${S}"/po/{ca_ES,cs_CZ,da_DK,el_GR,es_ES,et_EE,fi_FI,fr_FR,hr_HR,hu_HU,nl_NL,nn_NO,pl_PL,pt_PT,ro_RO,ru_RU,sl_SI}.po
	vdr-plugin-2_src_prepare

	fix_vdr_libsi_include reader.c

	eapply "${FILESDIR}/missing-include.diff"
}

src_install() {
	vdr-plugin-2_src_install

	local DOCS=( TODO FAQ example/channels.conf_* )
}
