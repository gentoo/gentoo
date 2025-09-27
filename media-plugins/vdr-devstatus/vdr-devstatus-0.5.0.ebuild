# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: display the usage status of the available DVB devices"
HOMEPAGE="https://github.com/vdr-projects/vdr-plugin-devstatus/"
SRC_URI="https://github.com/vdr-projects/vdr-plugin-devstatus/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vdr-plugin-devstatus-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-video/vdr:="
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="
	usr/lib/vdr/plugins/libvdr-.*
	usr/lib64/vdr/plugins/libvdr-.*"
PATCHES=(
	"${FILESDIR}/${P}-dvb-adapter-frontend.patch"
	"${FILESDIR}/${P}-memoryleak.patch"
)

src_prepare() {
	# remove untranslated .po files
	rm "${S}"/po/{ca_ES,cs_CZ,da_DK,el_GR,et_EE,hr_HR,hu_HU,nl_NL,nn_NO,pl_PL,pt_PT,ro_RO,sl_SI,sv_SE,tr_TR}.po \
		|| die "failed to remove untranslated .po files"

	vdr-plugin-2_src_prepare
}
