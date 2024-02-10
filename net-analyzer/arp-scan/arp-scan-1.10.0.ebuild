# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="ARP scanning and fingerprinting tool"
HOMEPAGE="https://github.com/royhills/arp-scan"
SRC_URI="https://github.com/royhills/arp-scan/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

DEPEND="
	net-libs/libpcap
	sys-libs/libcap
"
RDEPEND="
	${DEPEND}
	dev-lang/perl
"
# Needed for _F_S patch
BDEPEND="dev-build/autoconf-archive"

PATCHES=(
	"${FILESDIR}"/${PN}-1.10.0-dont-clobber-fortify-source.patch
)

src_prepare() {
	default
	eautoreconf
}
