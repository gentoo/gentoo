# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ADAMK
DIST_VERSION=1.07
inherit perl-module

DESCRIPTION="Utility functions to aid in parameter checking"

SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND=">=virtual/perl-Scalar-List-Utils-1.180.0"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-CBuilder-0.270.0
	>=virtual/perl-ExtUtils-MakeMaker-6.520.0
	>=virtual/perl-File-Spec-0.800.0
	test? ( virtual/perl-Test-Simple )
"
