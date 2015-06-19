# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Module-Build/Module-Build-0.420.500.ebuild,v 1.1 2015/06/13 12:37:07 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=LEONT
MODULE_VERSION=0.4205
inherit perl-module

DESCRIPTION="Build and install Perl modules"

SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	>=virtual/perl-Archive-Tar-1.09
	>=virtual/perl-CPAN-Meta-2.110.420
	>=virtual/perl-CPAN-Meta-YAML-0.3.0
	virtual/perl-Data-Dumper
	>=virtual/perl-ExtUtils-CBuilder-0.270.0
	virtual/perl-ExtUtils-Install
	virtual/perl-ExtUtils-Manifest
	>=virtual/perl-ExtUtils-ParseXS-2.210.0
	>=virtual/perl-File-Spec-0.820.0
	>=virtual/perl-File-Temp-0.150.0
	virtual/perl-Getopt-Long
	>=virtual/perl-Module-Metadata-1.0.2
	>=virtual/perl-Parse-CPAN-Meta-1.440.100
	>=virtual/perl-Perl-OSType-1
	virtual/perl-Test-Harness
	>=virtual/perl-Test-Simple-0.490.0
	virtual/perl-Text-ParseWords
	>=virtual/perl-version-0.870.0
"
DEPEND="${RDEPEND}"

SRC_TEST="do"
