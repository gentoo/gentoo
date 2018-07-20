# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MITHALDU
DIST_VERSION=0.35
inherit perl-module

DESCRIPTION="Inject modules into a CPAN::Mini mirror"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-aix"
IUSE="test"

RDEPEND="
	dev-perl/CPAN-Checksums
	>=dev-perl/CPAN-Mini-0.320.0
	virtual/perl-Carp
	>=dev-perl/Dist-Metadata-0.921.0
	>=virtual/perl-File-Path-2.70.0
	dev-perl/File-Slurp
	>=virtual/perl-File-Spec-2.70.0
	virtual/perl-File-Temp
	virtual/perl-Getopt-Long
	virtual/perl-IO-Compress
	virtual/perl-IO-Zlib
	dev-perl/libwww-perl
	dev-perl/YAML"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.400.0
	test? (
		>=dev-perl/HTTP-Server-Simple-0.70.0
		dev-perl/Test-TCP
		virtual/perl-Test-Simple
	)
"
# Tests fail with parallel testing
DIST_TEST="do"
src_test() {
	perl_rm_files t/pod-coverage.t t/pod.t
	perl-module_src_test
}
