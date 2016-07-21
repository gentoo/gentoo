# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Windowmaker dockapp which monitors up to 5 printqueues"
HOMEPAGE="http://www.ur.uklinux.net/wmlpq/"
SRC_URI="http://www.ur.uklinux.net/${PN}/dl/${P/-/_}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=">=x11-libs/libdockapp-0.7:="
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-makefile-ldflags.patch"

	sed -e 's#<dockapp.h>#<libdockapp/dockapp.h>#' -i *.c || die
}

src_compile() {
	emake CC=$(tc-getCC) LDFLAGS="${LDFLAGS}"
}

src_install() {
	dodir /usr/bin
	emake DESTDIR="${D}"/usr/bin install

	dodoc README sample.wmlpqrc
	newman wmlpq.1x wmlpq.1

	domenu "${FILESDIR}/${PN}.desktop"
}
