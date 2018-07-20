# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=TOKUHIROM
DIST_VERSION=0.23
inherit perl-module

DESCRIPTION="PSGI adapter for CGI"

SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE="test"

RDEPEND="
	>=dev-perl/CGI-3.630.0
	dev-perl/HTTP-Message
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.880.0
		>=dev-perl/Test-Requires-0.80.0
	)
"
src_test() {
	perl_rm_files t/author-pod-syntax.t
	perl-module_src_test
}
