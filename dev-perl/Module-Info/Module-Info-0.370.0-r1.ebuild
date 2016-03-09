# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=NEILB
DIST_VERSION=0.37
inherit perl-module

DESCRIPTION="Information about Perl modules"

SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/B-Utils-0.270.0
	virtual/perl-Carp
	>=virtual/perl-File-Spec-0.800.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
src_test() {
	perl_rm_files "t/zz_pod.t" "t/zy_pod_coverage.t"
	perl-module_src_test
}
