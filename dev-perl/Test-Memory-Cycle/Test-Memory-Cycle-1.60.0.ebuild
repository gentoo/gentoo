# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=PETDANCE
DIST_VERSION=1.06
inherit perl-module

DESCRIPTION="Check for memory leaks and circular memory references"

SLOT="0"
KEYWORDS="alpha amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND="
	>=dev-perl/Devel-Cycle-1.70.0
	virtual/perl-Getopt-Long
	dev-perl/PadWalker
	>=virtual/perl-Test-Simple-0.620.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

src_test() {
	perl_rm_files t/pod-coverage.t t/pod.t
	perl-module_src_test
}
