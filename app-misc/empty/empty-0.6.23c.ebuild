# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Small shell utility, similar to expect(1)"
HOMEPAGE="http://empty.sourceforge.net"
SRC_URI="https://download.sourceforge.net/empty/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="virtual/logger"

PATCHES=( "${FILESDIR}/${PN}-respect-LDFLAGS.patch" )

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin empty
	doman empty.1
	dodoc README.txt
	dodoc -r examples
}
