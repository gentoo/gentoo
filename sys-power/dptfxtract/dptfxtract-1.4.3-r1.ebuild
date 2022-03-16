# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Intel's Linux DPTF Extract Utility for generating thermald's thermal_conf.xml"
HOMEPAGE="https://github.com/intel/dptfxtract"
SRC_URI="https://github.com/intel/dptfxtract/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ipw3945"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND="sys-libs/glibc"
DEPEND=""

QA_PREBUILT="*"

src_install() {
	dobin "${PN}"
	einstalldocs
}
