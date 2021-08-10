# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=BTROTT
DIST_VERSION=0.02
inherit perl-module

DESCRIPTION="Create bubble-babble fingerprints"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

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
