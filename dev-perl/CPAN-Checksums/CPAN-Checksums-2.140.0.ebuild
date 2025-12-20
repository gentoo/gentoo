# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ANDK
DIST_VERSION=2.14
inherit perl-module

DESCRIPTION="Write a CHECKSUMS file for a directory as on CPAN"

SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-perl/Compress-Bzip2
	dev-perl/Data-Compare
	virtual/perl-Data-Dumper
	>=virtual/perl-Digest-MD5-2.360.0
	virtual/perl-Digest-SHA
	virtual/perl-Exporter
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	virtual/perl-IO
	virtual/perl-IO-Compress
	dev-perl/Module-Signature
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Path
		virtual/perl-Test-Simple
		virtual/perl-Time-HiRes
	)
"

PERL_RM_FILES=(
		t/00signature.t   # Online test, invalid if dist tweaked
		t/52podcover.t    # Author Test
		t/pod.t           # Author Test
	)
