# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Tool to test TCP and UDP throughput"
HOMEPAGE="https://codeberg.org/BSDforge/ttcp/"
SRC_URI="https://codeberg.org/BSDforge/ttcp/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~mips ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

PATCHES=(
	"${FILESDIR}/${PN}-1.13-unified-fix.patch"
)

src_configure() {
	tc-export CC
}

src_compile() {
	emake ttcp
}

src_install() {
	dobin	ttcp
	doman	ttcp.1
	dodoc	CHANGES LICENSE README
}
