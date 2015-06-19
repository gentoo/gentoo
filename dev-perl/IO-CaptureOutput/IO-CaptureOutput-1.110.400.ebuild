# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/IO-CaptureOutput/IO-CaptureOutput-1.110.400.ebuild,v 1.5 2015/04/12 13:07:12 zlogene Exp $

EAPI=5

MODULE_AUTHOR=DAGOLDEN
MODULE_VERSION=1.1104
inherit perl-module

DESCRIPTION="Capture STDOUT and STDERR from Perl code, subprocesses or XS"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~mips ~ppc ~ppc64 ~x86 ~x86-linux"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	>=virtual/perl-File-Temp-0.160.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? (
		>=virtual/perl-File-Spec-3.270.0
		virtual/perl-IO
		>=virtual/perl-Test-Simple-0.620.0
	)
"

SRC_TEST=do
