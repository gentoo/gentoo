# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="tapecat is a tape utility used to describe the physical content of a tape"
HOMEPAGE="http://www.itech.at/tapecat/"
SRC_URI="http://downloads.inventivetechnology.at/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="sys-apps/file:="
RDEPEND="${DEPEND}"

src_compile() {
	emake CFLAGS="${CFLAGS} -Wall -ansi"
}

src_install() {
	dobin tapecat
	doman tapecat.1
}
