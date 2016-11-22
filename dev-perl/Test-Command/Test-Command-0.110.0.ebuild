# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=DANBOO
DIST_VERSION=0.11
inherit perl-module

DESCRIPTION="Test routines for external commands"

SLOT="0"
KEYWORDS="alpha amd64 ~arm ~mips ppc ppc64 sparc x86"
IUSE=""

RDEPEND="
	>=virtual/perl-Test-Simple-0.620.0
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
"

src_test() {
	perl_rm_files t/pod-coverage.t t/pod.t
	perl-module_src_test
}
