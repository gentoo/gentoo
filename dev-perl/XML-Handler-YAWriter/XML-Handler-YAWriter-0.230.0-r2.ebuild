# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=KRAEHE
DIST_VERSION=0.23
inherit perl-module

DESCRIPTION="A Perl module providing a simple API to parsed XML instances"

LICENSE="GPL-2" # GPL
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=">=dev-perl/libxml-perl-0.07-r1"
DEPEND="${RDEPEND}"
