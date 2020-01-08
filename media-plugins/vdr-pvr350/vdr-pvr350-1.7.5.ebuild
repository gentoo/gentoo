# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

VERSION="1657" # every bump, new version

DESCRIPTION="VDR plugin: use a PVR350 as output device"
HOMEPAGE="https://projects.vdr-developer.org/projects/plg-pvr350"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=media-video/vdr-2
	media-sound/mpg123
	media-sound/twolame
	media-libs/a52dec"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P#vdr-}"

QA_FLAGS_IGNORED="
	usr/lib/vdr/plugins/libvdr-.*
	usr/lib64/vdr/plugins/libvdr-.*"

src_prepare() {
	# remove empty language files
	rm po/{ca_ES,cs_CZ,da_DK,el_GR,es_ES,et_EE,fi_FI,fr_FR,hr_HR,hu_HU,nl_NL,nn_NO,pl_PL,pt_PT,ro_RO,ru_RU,sl_SI,sv_SE,tr_TR}.po

	vdr-plugin-2_src_prepare
}
