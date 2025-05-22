# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Microsoft's NTLM authentication (libntlm) library"
HOMEPAGE="https://www.nongnu.org/libntlm/"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux"
IUSE="static-libs"

src_configure() {
	econf \
		--disable-gcc-warnings \
		$(use_enable static-libs static)
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
