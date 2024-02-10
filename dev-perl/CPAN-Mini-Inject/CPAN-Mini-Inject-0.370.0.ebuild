# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MITHALDU
DIST_VERSION=0.37
# Tests fail with parallel testing
DIST_TEST="do"
inherit perl-module

DESCRIPTION="Inject modules into a CPAN::Mini mirror"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/CPAN-Checksums-2.130.0
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
BDEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-0.400.0
	test? (
		>=dev-perl/HTTP-Server-Simple-0.70.0
		dev-perl/Test-InDistDir
		dev-perl/Test-TCP
		virtual/perl-Test-Simple
	)
"

PERL_RM_FILES=( t/pod-coverage.t t/pod.t )
