# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ANDK
DIST_VERSION=2.29
inherit perl-module

DESCRIPTION="Query, download and build perl modules from CPAN sites"

SLOT="0"
KEYWORDS="~amd64 ~m68k ~mips ~s390 ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+minimal ssl"

CRAZYDEPS="
	dev-perl/Archive-Zip
	dev-perl/CPAN-Checksums
	virtual/perl-CPAN-Meta
	>=virtual/perl-CPAN-Meta-Requirements-2.121.0
	virtual/perl-CPAN-Meta-YAML
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
	virtual/perl-Net-Ping
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

RDEPEND="
	!minimal? (
		${CRAZYDEPS}
		ssl? ( dev-perl/LWP-Protocol-https )
	)
"
BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? ( ${RDEPEND} )
"
