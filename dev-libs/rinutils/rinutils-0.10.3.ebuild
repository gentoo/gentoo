# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Set of C headers containing macros and static functions"
HOMEPAGE="https://www.shlomifish.org/open-source/projects/ https://github.com/shlomif/rinutils"
SRC_URI="https://github.com/shlomif/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-perl/Env-Path
		dev-perl/Path-Tiny
		dev-perl/Inline
		dev-perl/Inline-C
		dev-perl/Test-TrailingSpace
		dev-perl/Test-Differences
		dev-perl/IO-All
		dev-perl/Perl-Critic
		dev-perl/Perl-Tidy
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
		dev-perl/Test-Trap
		dev-util/cmocka
	)
"

PATCHES=( "${FILESDIR}/${P}-cmake-minreqver-3.10.patch" ) # bug #964580

src_configure() {
	local mycmakeargs=(
		-DDISABLE_APPLYING_RPATH=OFF
		-DWITH_TEST_SUITE=$(usex test ON OFF)
	)

	cmake_src_configure
}
