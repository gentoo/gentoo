# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="An improved version of cli-crypt (encrypts data sent to it from the cli)"
HOMEPAGE="http://xjack.org/pwcrypt/"
SRC_URI="http://xjack.org/pwcrypt/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DOCS=( CREDITS README )

src_prepare()  {
	default
	sed -i "s/make\( \|$\)/\$(MAKE)\1/g" Makefile.in || die
	sed -i \
		-e "/^LDFLAGS/s/= /= @LDFLAGS@ /" \
		-e "/-install/s/ -s//" \
		src/Makefile.in || die

	tc-export CC
}
