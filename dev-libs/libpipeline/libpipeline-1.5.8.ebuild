# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/cjwatson.asc
inherit libtool verify-sig

DESCRIPTION="Pipeline manipulation library"
HOMEPAGE="https://libpipeline.nongnu.org/"
SRC_URI="
	mirror://nongnu/${PN}/${P}.tar.gz
	verify-sig? ( mirror://nongnu/${PN}/${P}.tar.gz.asc )
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-libs/check )"
BDEPEND="
	virtual/pkgconfig
	verify-sig? ( sec-keys/openpgp-keys-cjwatson )
"

src_prepare() {
	default
	elibtoolize
}

src_install() {
	default

	find "${ED}" -type f -name "*.la" -delete || die
}
