# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs flag-o-matic autotools

MY_PN=${PN/-/_}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Similar to dd but can copy from source with errors"
HOMEPAGE="http://www.garloff.de/kurt/linux/ddrescue/"
SRC_URI="http://www.garloff.de/kurt/linux/ddrescue/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="static"

S=${WORKDIR}/${MY_PN}

src_prepare() {
	sed -i \
		-e 's:-ldl:$(LDFLAGS) -ldl:' \
		Makefile
	eautoreconf
}

src_compile() {
	use static && append-ldflags -static

	# The Makefile is a mess.  Override a few vars rather than patch it.
	emake \
		RPM_OPT_FLAGS="${CFLAGS} ${CPPFLAGS}" \
		CFLAGS_OPT='$(CFLAGS)' \
		CC="$(tc-getCC)"
}

src_install() {
	# easier to install by hand than trying to make sense of the Makefile.
	dobin dd_rescue
	dodoc README.dd_rescue
	doman dd_rescue.1
}
