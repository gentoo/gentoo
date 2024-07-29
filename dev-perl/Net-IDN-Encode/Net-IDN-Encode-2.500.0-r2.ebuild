# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CFAERBER
DIST_VERSION=2.500
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Internationalizing Domain Names in Applications (IDNA)"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	virtual/perl-Unicode-Normalize
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-CBuilder
	>=dev-perl/Module-Build-0.420.0
	test? (
		virtual/perl-Test-Simple
		dev-perl/Test-NoWarnings
	)
"

PATCHES=(
	"${FILESDIR}"/${PV}-use-uvchr_to_utf8_flags-instead-of-uvuni_to_utf8_fla.patch
)
