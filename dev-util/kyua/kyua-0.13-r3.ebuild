# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="Testing framework for infrastructure software"
HOMEPAGE="https://github.com/jmmv/kyua"
SRC_URI="https://github.com/jmmv/kyua/releases/download/${P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"
IUSE="test"

# Tests fail
RESTRICT="test"

RDEPEND="
	dev-db/sqlite:3
	dev-libs/atf
	dev-lua/lutok
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? ( dev-libs/atf )
"

src_configure() {
	# Uses std::auto_ptr (deprecated in c++11, removed in c++17)
	append-cxxflags "-std=c++14"

	default
}

src_install() {
	default
	rm -r "${ED}"/usr/tests || die
}
