# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/gputils/gputils-1.4.0.ebuild,v 1.1 2015/07/04 08:56:49 perfinion Exp $

EAPI="5"

inherit toolchain-funcs

DESCRIPTION="Collection of tools including assembler, linker and librarian for PIC microcontrollers"
HOMEPAGE="http://gputils.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

src_configure() {
	tc-ld-disable-gold
	default
}

src_install() {
	default
	dodoc doc/gputils.pdf
}
