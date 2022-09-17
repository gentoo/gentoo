# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Port of libtls from LibreSSL to OpenSSL"
HOMEPAGE="https://git.causal.agency/libretls/about/"
SRC_URI="https://causal.agency/libretls/${P}.tar.gz"

LICENSE="ISC"
SLOT="0/22"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

DEPEND="
	dev-libs/openssl:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
