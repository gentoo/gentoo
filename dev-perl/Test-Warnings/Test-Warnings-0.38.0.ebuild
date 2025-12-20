# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=0.038
inherit perl-module

DESCRIPTION="Test for warnings and the lack of them"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	!<dev-perl/File-pushd-1.4.0
"
BDEPEND="
	${RDEPEND}
	test? (
		>=dev-perl/CPAN-Meta-Check-0.11.0
	)
"
