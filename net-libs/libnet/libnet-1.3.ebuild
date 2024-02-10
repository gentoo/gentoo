# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Library for commonly used low-level network functions"
HOMEPAGE="http://libnet-dev.sourceforge.net/ https://github.com/libnet/libnet"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD BSD-2"
SLOT="1.1"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="static-libs test"
# Fails in sandbox, tries to access /proc/self/uid_map.
RESTRICT="!test? ( test ) test"

# doxygen needed for man pages
BDEPEND="
	app-text/doxygen
	test? ( dev-util/cmocka )
"

DOCS=( ChangeLog.md README.md doc/MIGRATION.md )

src_configure() {
	local myeconfargs=(
		--enable-doxygen-man

		$(use_enable static-libs static)
		$(use_enable test tests)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}
