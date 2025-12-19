# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CFAERBER
DIST_VERSION=2.500
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Internationalizing Domain Names in Applications (IDNA)"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

BDEPEND="
	>=dev-perl/Module-Build-0.420.0
	test? (
		dev-perl/Test-NoWarnings
	)
"

PATCHES=(
	"${FILESDIR}"/${PV}-use-uvchr_to_utf8_flags-instead-of-uvuni_to_utf8_fla.patch
)
