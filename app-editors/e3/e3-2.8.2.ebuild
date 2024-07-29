# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_P="${PN}-$(ver_rs 2 '')"
DESCRIPTION="Very tiny editor in ASM with emacs, pico, wordstar, and vi keybindings"
HOMEPAGE="https://sites.google.com/site/e3editor/"
SRC_URI="https://sites.google.com/site/e3editor/Home/${MY_P}.tgz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="-* amd64 x86"

BDEPEND=">=dev-lang/nasm-2.09.04"

S="${WORKDIR}/${MY_P}"
PATCHES=("${FILESDIR}"/${P}-makefile.patch)

# Suppress false positive QA warnings #726484 #924244
QA_FLAGS_IGNORED="/usr/bin/e3"
QA_PRESTRIPPED="/usr/bin/e3"

src_compile() {
	emake -- $(usev amd64 64 || usev x86 32 || die) \
		LD="$(tc-getLD)" DEBUG=true
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
