# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=JGOFF
DIST_VERSION=0.06
inherit perl-module

DESCRIPTION="format Pod as LaTeX"
SLOT="0"
KEYWORDS="amd64 x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	>=virtual/perl-Pod-Simple-0.10.0
"
DEPEND="${RDEPEND}"
