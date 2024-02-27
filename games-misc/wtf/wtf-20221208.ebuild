# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit prefix

DESCRIPTION="Translates acronyms for you"
HOMEPAGE="https://netbsd.org/"
SRC_URI="https://sourceforge.net/projects/bsd${PN}/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc64 ~riscv ~s390 ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="!<=games-misc/bsd-games-3"

src_prepare() {
	default
	hprefixify wtf
}

src_install() {
	dobin wtf
	doman wtf.6
	insinto /usr/share/misc
	doins acronyms*
}
