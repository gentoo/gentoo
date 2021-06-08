# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 toolchain-funcs

DESCRIPTION="control magnetic tape drive operation"
HOMEPAGE="https://github.com/iustin/mt-st"
EGIT_REPO_URI="https://github.com/iustin/mt-st"

LICENSE="GPL-2"
SLOT="0"

src_configure() {
	tc-export CC
}

src_install() {
	dosbin mt stinit
	doman mt.1 stinit.8
	dodoc README* stinit.def.examples
}
