# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ANDK
DIST_VERSION=2.29
inherit perl-module

DESCRIPTION="Query, download and build perl modules from CPAN sites"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

# parallel testing fails, run tests sequentially #827014
DIST_TEST=do

CRAZYDEPS="
	dev-perl/Archive-Zip
	dev-perl/CPAN-Checksums
	>=virtual/perl-CPAN-Meta-Requirements-2.121.0
	dev-perl/CPAN-Perl-Releases
	dev-perl/Compress-Bzip2
	dev-perl/Expect
	dev-perl/File-HomeDir
	dev-perl/File-Which
	dev-perl/libwww-perl
	dev-perl/Log-Log4perl
	dev-perl/Module-Build
	dev-perl/Module-Signature
	dev-perl/TermReadKey
	>=virtual/perl-Test-Harness-2.620.0
	dev-perl/Text-Glob
	dev-perl/YAML
	dev-perl/YAML-Syck
"
# ^ this is what should be in RDEPEND for *full* functionality...
