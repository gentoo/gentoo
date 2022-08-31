# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="Multicast file transfer tool"
HOMEPAGE="https://www.udpcast.linux.lu/"
SRC_URI="https://www.udpcast.linux.lu/download/${P}.tar.gz"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="hardened"

BDEPEND="dev-lang/perl"

PATCHES=(
	"${FILESDIR}"/${P}-musl.patch
)

src_configure() {
	use hardened || append-cppflags -DUSE_ASSEMBLER

	default
}

src_install() {
	default
	dodoc *.txt
}
