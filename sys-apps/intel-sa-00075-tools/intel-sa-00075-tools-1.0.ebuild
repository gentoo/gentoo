# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

MY_PN="INTEL-SA-00075-Linux-Detection-And-Mitigation-Tools"

DESCRIPTION="Tools from Intel to detect and mitigate the AMT/MEI vulnerability"
HOMEPAGE="https://downloadcenter.intel.com/download/26799/INTEL-SA-00075-Linux-Detection-and-Mitigation-Tools"
SRC_URI="https://github.com/intel/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${MY_PN}-${PV}"

PATCHES=("${FILESDIR}/${PN}-makefile.patch")

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}
