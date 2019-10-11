# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

MY_P="ELFIO-${PV}"
DESCRIPTION="ELF reader and producer implemented as a C++ library"
HOMEPAGE="http://elfio.sourceforge.net/"
SRC_URI="mirror://sourceforge/elfio/${MY_P}.tar.gz"

S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

PATCHES=( "${FILESDIR}/${P}-shared.patch" )

src_prepare() {
	default
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS NEWS README
}
