# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=JSTOWE
DIST_VERSION=2.37
DIST_EXAMPLES=("example/*")
inherit perl-module

DESCRIPTION="Change terminal modes, and perform non-blocking reads"

SLOT="0"
KEYWORDS="alpha amd64 ~arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND=">=virtual/perl-ExtUtils-MakeMaker-6.580.0"
