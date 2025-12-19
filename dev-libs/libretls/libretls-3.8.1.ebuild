# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libtool

DESCRIPTION="Port of libtls from LibreSSL to OpenSSL"
HOMEPAGE="https://git.causal.agency/libretls/about/"
SRC_URI="https://causal.agency/libretls/${P}.tar.gz"

LICENSE="ISC"
SLOT="0/28"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

DEPEND="
	dev-libs/openssl:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

QA_CONFIG_IMPL_DECL_SKIP+=(
	# checks for va_copy and __va_copy as a fallback, ignores result of
	# latter if former exists. The latter is private and doesn't exist
	# on musl; ignore it since it doesn't even matter. bug #906534
	__va_copy
)

src_prepare() {
	default
	elibtoolize
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
