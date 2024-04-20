# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Tips, tricks and examples for the Z shell"
HOMEPAGE="
	https://grml.org/zsh/zsh-lovers.html
	https://github.com/grml/zsh-lovers
"
SRC_URI="https://deb.grml.org/pool/main/z/${PN}/${PN}_${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

DEPEND="app-text/asciidoc"

src_compile() {
	asciidoc ${PN}.1.txt || die
	mv ${PN}.1.html ${PN}.html || die
	a2x -f manpage ${PN}.1.txt || die
}

src_install() {
	doman ${PN}.1
	dodoc ${PN}.html
}
