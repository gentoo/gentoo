# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Utility to generate hashcash tokens"
HOMEPAGE="http://www.hashcash.org"
SRC_URI="http://www.hashcash.org/source/${P}.tgz"

LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

src_prepare() {
	default
	sed -i -e "/COPT_GENERIC = -O3/d" Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" generic
}

src_install() {
	dobin hashcash
	doman hashcash.1
	dodoc CHANGELOG
	insinto /usr/share/doc/${PF}/examples
	doins contrib/hashcash-{request,sendmail{,.txt}} \
		contrib/hashfork.{c,py,txt}
}
