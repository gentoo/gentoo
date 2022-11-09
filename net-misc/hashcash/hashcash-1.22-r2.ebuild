# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Utility to generate hashcash tokens"
HOMEPAGE="http://www.hashcash.org"
SRC_URI="http://www.hashcash.org/source/${P}.tgz"

LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-clang16.patch
)

src_prepare() {
	default

	sed -i -e "/COPT_GENERIC = -O3/d" Makefile || die
}

src_compile() {
	tc-export AR CC

	emake generic
}

src_install() {
	dobin hashcash
	doman hashcash.1

	dodoc CHANGELOG

	docinto examples
	dodoc contrib/hashcash-{request,sendmail{,.txt}} contrib/hashfork.{c,py,txt}

	docompress -x /usr/share/doc/${PF}/examples
}
