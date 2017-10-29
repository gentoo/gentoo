# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=TIMB
DIST_VERSION=1.637
DIST_EXAMPLES=("ex/*")
inherit perl-module eutils

DESCRIPTION="Database independent interface for Perl"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	>=dev-perl/PlRPC-0.200.0
	>=virtual/perl-Sys-Syslog-0.170.0
	virtual/perl-File-Spec
	!<=dev-perl/SQL-Statement-1.330.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.480.0
	test? (
		>=virtual/perl-Test-Simple-0.900.0
	)
"
src_test() {
	perl_rm_files t/pod-coverage.t t/pod.t
	perl-module_src_test
}
