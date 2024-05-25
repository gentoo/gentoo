# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="Testing framework for infrastructure software"
HOMEPAGE="https://github.com/freebsd/kyua"
SRC_URI="https://github.com/freebsd/kyua/releases/download/${P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

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

	# Skip coredump tests; they fail when sudo sets RLIMIT_CORE = 0.
	cat >"${T}/kyua.conf" <<-EOF || die
	syntax(2)
	test_suites.kyua.run_coredump_tests = "false"
	EOF
	local -x KYUA_CONFIG_FILE_FOR_CHECK="${T}/kyua.conf"

	default
}

src_install() {
	default
	rm -r "${ED}"/usr/tests || die
}
