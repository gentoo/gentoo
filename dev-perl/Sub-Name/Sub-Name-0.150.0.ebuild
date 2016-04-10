# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=0.15
inherit perl-module

DESCRIPTION="(Re)name a sub"

SLOT="0"
KEYWORDS="~amd64 ~arm64 ~mips ~s390 ~sh ~x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="test suggested"

RDEPEND="
	>=virtual/perl-Exporter-5.570.0
	virtual/perl-XSLoader
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		suggested? (
			dev-perl/Devel-CheckBin
		)
		virtual/perl-File-Spec
		virtual/perl-Module-Metadata
		>=virtual/perl-Test-Simple-0.880.0
	)
"
