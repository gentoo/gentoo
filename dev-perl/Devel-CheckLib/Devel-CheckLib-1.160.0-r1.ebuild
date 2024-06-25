# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MATTN
DIST_VERSION=1.16
inherit perl-module

DESCRIPTION="Check that a library is available"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	virtual/perl-Exporter
	virtual/perl-File-Spec
	>=virtual/perl-File-Temp-0.160.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Capture-Tiny
		>=dev-perl/Mock-Config-0.20.0
		>=virtual/perl-Test-Simple-0.880.0
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-1.14-test-toolchain.patch"
)
