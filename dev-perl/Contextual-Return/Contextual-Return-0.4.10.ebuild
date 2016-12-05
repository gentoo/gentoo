# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=DCONWAY
DIST_VERSION=0.004010
inherit perl-module

DESCRIPTION="Create context-sensitive return values"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-aix"
IUSE="test"

RDEPEND="
	dev-perl/Want
	virtual/perl-version
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

src_test() {
	perl_rm_files t/pod.t
	perl-module_src_test
}
