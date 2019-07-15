# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="HTS voices for Festival"
HOMEPAGE="http://hts.sp.nitech.ac.jp/"
SITE="http://hts.sp.nitech.ac.jp/archives/${PV}"
SRC_URI="${SITE}/festvox_nitech_us_awb_arctic_hts-${PV}.tar.bz2
	${SITE}/festvox_nitech_us_bdl_arctic_hts-${PV}.tar.bz2
	${SITE}/festvox_nitech_us_clb_arctic_hts-${PV}.tar.bz2
	${SITE}/festvox_nitech_us_jmk_arctic_hts-${PV}.tar.bz2
	${SITE}/festvox_nitech_us_rms_arctic_hts-${PV}.tar.bz2
	${SITE}/festvox_nitech_us_slt_arctic_hts-${PV}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=app-accessibility/festival-1.96"

S=${WORKDIR}

src_install() {
	insinto /usr/share/festival/voices
	doins -r lib/voices/.
}
