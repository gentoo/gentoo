# Copyright 2017-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Testing framework for infrastructure software"
HOMEPAGE="https://github.com/freebsd/kyua"
SRC_URI="https://github.com/freebsd/kyua/archive/refs/tags/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-db/sqlite:3
	>=dev-lua/lutok-0.5
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? ( >=dev-libs/atf-0.22 )
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# bug #948053
	filter-lto

	# Skip coredump tests; they fail when sudo sets RLIMIT_CORE = 0.
	cat >"${T}/kyua.conf" <<-EOF || die
	syntax(2)
	test_suites.kyua.run_coredump_tests = "false"
	EOF
	local -x KYUA_CONFIG_FILE_FOR_CHECK="${T}/kyua.conf"

	econf $(use_enable test atf)
}

src_install() {
	default
	rm -rf "${ED}"/usr/tests || die
}
