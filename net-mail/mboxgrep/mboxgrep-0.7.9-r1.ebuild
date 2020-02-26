# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils

DESCRIPTION="Grep for mbox files"
SRC_URI="mirror://sourceforge/mboxgrep/${P}.tar.gz"
HOMEPAGE="http://mboxgrep.sf.net"

DEPEND=""
RDEPEND="${DEPEND}"

SLOT="0"
LICENSE="GPL-2+"
KEYWORDS="~amd64 ppc x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-ldflags.patch
}

src_install() {
	emake \
		prefix="${D}"/usr \
		mandir="${D}"/usr/share/man \
		infodir="${D}"/usr/share/info \
		install
	dodoc ChangeLog NEWS TODO README
}
