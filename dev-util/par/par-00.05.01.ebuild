# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/par/par-00.05.01.ebuild,v 1.8 2010/08/11 01:12:34 jer Exp $

inherit toolchain-funcs

DESCRIPTION="par manipulates PalmOS database files"
HOMEPAGE="http://www.djw.org/product/palm/par/"
SRC_URI="http://www.djw.org/product/palm/par/prc.tgz"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

DEPEND="!app-text/par
	!app-arch/par"
RDEPEND="${DEPEND}"

S="${WORKDIR}/prc"

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		|| die 'Failed to compile!'
	emake par.man || die 'Failed to make man page!'
}

src_install () {
	dobin par || die 'dobin failed'
	dolib *.a || die 'dolib *.a failed'

	newman par.man par.1 || die 'newman failed'
}
