# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DMUEY
DIST_VERSION=0.23
DIST_EXAMPLES=("example.pl")
inherit perl-module

DESCRIPTION="A Perl access to the TCP Wrappers interface"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="sys-apps/tcp-wrappers"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
	virtual/perl-ExtUtils-CBuilder
	test? (
		virtual/perl-Test-Simple
		dev-perl/Test-Exception
	)
"
src_test() {
	perl_rm_files t/03_pod.t t/02_maintainer.t
	perl-module_src_test
}
