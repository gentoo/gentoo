# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Intel's Linux DPTF Extract Utility for generating thermald's thermal_conf.xml"
HOMEPAGE="https://github.com/intel/dptfxtract"
SRC_URI="https://github.com/intel/dptfxtract/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ipw3945"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND=""
DEPEND=""

QA_PREBUILT="*"

src_install() {
	dobin "${PN}"
	einstalldocs
}
