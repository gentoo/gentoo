# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BTROTT
DIST_VERSION=0.02
inherit perl-module

DESCRIPTION="Create bubble-babble fingerprints"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

BDEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-6.420.0
"

PATCHES=(
	# https://github.com/btrott/Digest-BubbleBabble/pull/1
	"${FILESDIR}/0.02-dot-in-inc.patch"
	"${FILESDIR}/${PN}-0.02-no-test-base.patch"
)

PERL_RM_FILES=(
	inc/Spiffy.pm
	inc/Test/Base.pm
	inc/Test/Base/Filter.pm
	inc/Test/Builder.pm
	inc/Test/Builder/Module.pm
	inc/Test/More.pm
	inc/Module/Install/TestBase.pm
)
