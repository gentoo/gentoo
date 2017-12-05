# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

DESCRIPTION="Tools including assembler, linker and librarian for PIC microcontrollers"
HOMEPAGE="http://gputils.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

src_install() {
	default
	dodoc doc/gputils.pdf
}
