# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="DHCP Packet Analyzer/tcpdump postprocessor"
HOMEPAGE="https://www.mavetju.org/unix/general.php"
SRC_URI="https://www.mavetju.org/download/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm ~mips x86"

# for pod2man
BDEPEND="dev-lang/perl"
RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-Makefile.patch
	"${FILESDIR}"/${P}-debian.patch
	"${FILESDIR}"/${P}-endianness.patch
)

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin ${PN}
	doman ${PN}.8
	dodoc CHANGES CONTACT
}
