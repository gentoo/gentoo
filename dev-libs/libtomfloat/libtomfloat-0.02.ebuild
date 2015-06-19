# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libtomfloat/libtomfloat-0.02.ebuild,v 1.9 2012/06/03 02:31:47 vapier Exp $

EAPI="4"

inherit toolchain-funcs multilib

DESCRIPTION="library for floating point number manipulation"
HOMEPAGE="http://libtom.org/"
SRC_URI="http://libtom.org/files/ltf-${PV}.tar.bz2"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="dev-libs/libtommath"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i \
		-e 's:\<ar\>:$(AR):' \
		-e 's:\<ranlib\>:$(RANLIB):' \
		-e "/^LIBPATH/s:/lib:/$(get_libdir):" \
		makefile || die
	tc-export AR CC RANLIB
}

src_install() {
	default
	dodoc changes.txt *.pdf WARNING
	docinto demos ; dodoc demos/*
}
