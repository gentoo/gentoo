# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs vcs-snapshot

DESCRIPTION="A general purpose fuzzer"
HOMEPAGE="https://gitlab.com/akihe/radamsa"
SRC_URI="
	https://gitlab.com/akihe/radamsa/-/archive/v${PV}/${P}.tar.gz
	https://gitlab.com/akihe/radamsa/uploads/a2228910d0d3c68d19c09cee3943d7e5/${P}.c.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT=test # needs an owl-lisp

DOCS=( LICENCE NEWS README.md )

src_prepare() {
	default

	cp ../${P}.c ./radamsa.c || die
}

src_compile() {
	emake bin/radamsa CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin bin/radamsa
	# avoid man compression by build system
	doman doc/radamsa.1

	einstalldocs
}
