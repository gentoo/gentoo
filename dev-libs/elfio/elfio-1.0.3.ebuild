# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils autotools

MY_P=ELFIO-${PV}
DESCRIPTION="ELF reader and producer implemented as a C++ library"
HOMEPAGE="http://elfio.sourceforge.net/"
SRC_URI="mirror://sourceforge/elfio/${MY_P}.tar.gz"

S="${WORKDIR}"/${MY_P}

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-shared.patch
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS NEWS README
}
