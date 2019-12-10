# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=TADAM
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="Mocks LWP::UserAgent and dispatches your requests/responses"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	virtual/perl-Exporter
	dev-perl/HTTP-Message
	dev-perl/libwww-perl
	dev-perl/Test-MockObject
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		virtual/perl-File-Spec
		dev-perl/Test-Exception
	)
"
src_test() {
	perl_rm_files t/release-pod-coverage.t t/release-pod-syntax.t
	perl-module_src_test
}
