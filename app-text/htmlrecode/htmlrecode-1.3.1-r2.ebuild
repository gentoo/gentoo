# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Recodes HTML file using a new character set"
HOMEPAGE="https://bisqwit.iki.fi/source/htmlrecode.html"
SRC_URI="https://bisqwit.iki.fi/src/arch/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

PATCHES=( "${FILESDIR}/${P}-ar.patch" )

src_prepare() {
	touch .depend argh/.depend || die
	default
}

src_configure() { :; }

src_compile() {
	local makeopts=(
		AR="$(tc-getAR)"
		CPPDEBUG=
		CXX="$(tc-getCXX)"
		CXXFLAGS="${CXXFLAGS}"
		LDFLAGS="${LDFLAGS}"
	)
	emake "${makeopts[@]}" -C argh libargh.a
	emake "${makeopts[@]}" htmlrecode
}

src_install() {
	dobin htmlrecode
	dodoc README.html
}
