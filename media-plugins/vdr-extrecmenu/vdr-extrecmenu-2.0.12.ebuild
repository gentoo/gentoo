# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: Extended recordings menu (NG)"
HOMEPAGE="https://gitlab.com/kamel5/extrecmenung"
SRC_URI="https://gitlab.com/kamel5/extrecmenung/-/archive/v${PV}/extrecmenung-v${PV}.tar.bz2 -> ${P}.tbz2"
S="${WORKDIR}/extrecmenung-v${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

DEPEND="media-video/vdr"
RDEPEND="${DEPEND}
	media-fonts/vdrsymbols-ttf"

src_prepare() {
	rm "${S}"/po/{ca_ES,da_DK,el_GR,et_EE,hr_HR,hu_HU,nl_NL,nn_NO,pl_PL,pt_PT,ro_RO,ru_RU,sl_SI,sv_SE,tr_TR}.po || die

	vdr-plugin-2_src_prepare
}

src_install() {
	vdr-plugin-2_src_install

	cd "${S}/scripts"
	dobin dvdarchive.sh hddarchive.sh

	insinto /etc/vdr
	doins "${FILESDIR}"/dvdarchive.conf
}
