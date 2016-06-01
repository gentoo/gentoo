# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=TOKUHIROM
DIST_VERSION=0.10
inherit perl-module

DESCRIPTION="Checks to see if the module can be loaded"

SLOT="0"
KEYWORDS="alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND=">=virtual/perl-Test-Simple-0.470.0"

DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
"
