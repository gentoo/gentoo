# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=PERIGRIN
DIST_VERSION=1.12
inherit perl-module

DESCRIPTION="A Perl module that offers a simple to process namespaced XML names"

SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

DEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? ( virtual/perl-Test-Simple )
"
