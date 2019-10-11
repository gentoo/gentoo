# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Tips, tricks and examples for the Z shell"
HOMEPAGE="https://grml.org/zsh/zsh-lovers.html"
SRC_URI="https://deb.grml.org/pool/main/z/${PN}/${PN}_${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

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
