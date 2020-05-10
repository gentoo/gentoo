# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="${PN}-$(ver_rs 2 '')"
DESCRIPTION="Very tiny editor in ASM with emacs, pico, wordstar, and vi keybindings"
HOMEPAGE="https://sites.google.com/site/e3editor/"
SRC_URI="https://sites.google.com/site/e3editor/Home/${MY_P}.tgz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="-* amd64 x86"
RESTRICT="strip"

BDEPEND=">=dev-lang/nasm-2.09.04"

S="${WORKDIR}/${MY_P}"
PATCHES=("${FILESDIR}"/${P}-makefile.patch)

src_compile() {
	emake -- $(usex amd64 64 32) LD="$(tc-getLD)"
}

src_install() {
	dobin e3
	dosym e3 /usr/bin/e3em
	dosym e3 /usr/bin/e3ne
	dosym e3 /usr/bin/e3pi
	dosym e3 /usr/bin/e3vi
	dosym e3 /usr/bin/e3ws

	newman e3.man e3.1
	dodoc ChangeLog README README.v2.7.1
	docinto html
	dodoc e3.html
}
