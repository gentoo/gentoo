# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Tool to create very small elf binary from pure binary files"
HOMEPAGE="http://sed.free.fr/tinlink/"
SRC_URI="http://sed.free.fr/tinlink/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.0-Add-missing-include-for-strlen.patch
)

src_prepare() {
	default
	rm Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" tinlink
}

src_install() {
	dobin tinlink
	dodoc AUTHORS README example.asm
}
