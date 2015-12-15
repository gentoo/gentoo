# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

MY_PN="${PN/-/_}"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Simplifies TCP/IP socket operations"
HOMEPAGE="http://horms.net/projects/vanessa/"
SRC_URI="http://horms.net/projects/vanessa/download/${MY_PN}/${PV}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

DEPEND=">=dev-libs/vanessa-logger-0.0.6"

S=${WORKDIR}/${MY_P}

src_compile() {
	econf || die "error configure"
	emake || die "error compiling"
}

src_install() {
	make DESTDIR="${D}" install || die "error installing"
	dodoc README NEWS AUTHORS TODO
}
