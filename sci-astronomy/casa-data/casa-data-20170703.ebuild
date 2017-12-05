# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MYPN=WSRT_Measures

DESCRIPTION="Data and tables for the CASA software"
HOMEPAGE="https://github.com/casacore/casacore/"
SRC_URI="ftp://ftp.astron.nl/outgoing/Measures/${MYPN}_${PV}-000001.ztar -> ${P}.tar.Z"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

LICENSE="LGPL-3"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install(){
	insinto /usr/share/casa/data
	doins -r *
}
