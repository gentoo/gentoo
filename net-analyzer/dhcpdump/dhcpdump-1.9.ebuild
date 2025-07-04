# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="DHCP Packet Analyzer/tcpdump postprocessor"
HOMEPAGE="https://github.com/bbonev/dhcpdump https://www.mavetju.org/unix/general.php"
SRC_URI="https://github.com/bbonev/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm ~mips x86"

# for pod2man
BDEPEND="dev-lang/perl"
DEPEND="net-libs/libpcap"
RDEPEND="${DEPEND}"

src_compile() {
	tc-export CC
	emake
}

src_install() {
	dobin ${PN}
	doman ${PN}.8
	einstalldocs
}
