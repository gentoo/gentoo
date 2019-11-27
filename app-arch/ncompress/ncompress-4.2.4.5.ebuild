# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit toolchain-funcs

DESCRIPTION="Classic compress & uncompress programs for .Z (LZW) files"
HOMEPAGE="https://github.com/vapier/ncompress"
SRC_URI="https://github.com/vapier/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE=""

src_compile() {
	tc-export CC
	emake
}

src_install() {
	dobin compress
	dosym compress /usr/bin/uncompress
	doman compress.1 uncompress.1
	dodoc Acknowleds Changes LZW.INFO README.md
}
