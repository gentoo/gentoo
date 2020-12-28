# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Tips, tricks and examples for the Z shell"
HOMEPAGE="http://grml.org/zsh/zsh-lovers.html"
SRC_URI="http://deb.grml.org/pool/main/z/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

DEPEND="app-text/asciidoc"

src_compile() {
	asciidoc zsh-lovers.1.txt || die
	mv zsh-lovers.1.html zsh-lovers.html || die
	a2x -f manpage zsh-lovers.1.txt || die
}

src_install() {
	doman  zsh-lovers.1
	dohtml zsh-lovers.html
	dodoc README
}
