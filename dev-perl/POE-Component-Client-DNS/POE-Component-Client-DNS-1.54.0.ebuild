# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
DIST_AUTHOR=RCAPUTO
DIST_VERSION=1.054
inherit perl-module

DESCRIPTION="Non-blocking, parallel DNS client"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Net-DNS-0.650.0
	>=dev-perl/POE-1.294.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.960.0
		>=dev-perl/Test-NoWarnings-1.20.0
	)
"

src_test() {
	perl_rm_files t/author-pod-coverage.t t/author-pod-syntax.t
	perl-module_src_test
}
