# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ANDK
DIST_VERSION=2.29
inherit perl-module

DESCRIPTION="Query, download and build perl modules from CPAN sites"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

# parallel testing fails, run tests sequentially #827014
DIST_TEST=do

CRAZYDEPS="
	dev-perl/Archive-Zip
	dev-perl/CPAN-Checksums
	virtual/perl-CPAN-Meta
	>=virtual/perl-CPAN-Meta-Requirements-2.121.0
	dev-perl/CPAN-Perl-Releases
	dev-perl/Compress-Bzip2
	virtual/perl-Data-Dumper
	virtual/perl-Digest-MD5
	virtual/perl-Digest-SHA
	dev-perl/Expect
	virtual/perl-Exporter
	virtual/perl-ExtUtils-CBuilder
	dev-perl/File-HomeDir
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	dev-perl/File-Which
	virtual/perl-HTTP-Tiny
	virtual/perl-IO-Compress
	virtual/perl-IO-Zlib
	virtual/perl-JSON-PP
	dev-perl/libwww-perl
	dev-perl/Log-Log4perl
	virtual/perl-MIME-Base64
	dev-perl/Module-Build
	dev-perl/Module-Signature
	virtual/perl-Parse-CPAN-Meta
	virtual/perl-Scalar-List-Utils
	virtual/perl-Socket
	dev-perl/TermReadKey
	>=virtual/perl-Test-Harness-2.620.0
	virtual/perl-Test-Simple
	dev-perl/Text-Glob
	virtual/perl-Text-ParseWords
	virtual/perl-Text-Tabs+Wrap
	dev-perl/YAML
	dev-perl/YAML-Syck
"
# ^ this is what should be in RDEPEND for *full* functionality...
