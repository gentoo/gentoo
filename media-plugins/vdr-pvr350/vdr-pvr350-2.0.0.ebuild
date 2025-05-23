# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: use a PVR350 as output device"
HOMEPAGE="https://github.com/vdr-projects/vdr-plugin-pvr350/"
SRC_URI="https://github.com/vdr-projects/vdr-plugin-pvr350/archive/refs/tags/${PV}.tar.gz -> ${P}.tgz"
S="${WORKDIR}/vdr-plugin-pvr350-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=media-video/vdr-2.6
	media-sound/twolame
	media-sound/mpg123-base
	media-libs/a52dec"
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="
	usr/lib/vdr/plugins/libvdr-.*
	usr/lib64/vdr/plugins/libvdr-.*"

src_prepare() {
	# remove empty language files
	rm po/{ca_ES,cs_CZ,da_DK,el_GR,es_ES,et_EE,fi_FI,fr_FR,hr_HR,hu_HU,nl_NL,nn_NO,pl_PL,pt_PT,ro_RO,ru_RU,sl_SI,sv_SE,tr_TR}.po

	vdr-plugin-2_src_prepare
}
