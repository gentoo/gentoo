# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=0.20
inherit perl-module

DESCRIPTION="Execute code after a scope finished compilation"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ppc ~ppc64 ~sparc x86 ~ppc-aix ~x86-fbsd ~x64-macos"
IUSE="test"

RDEPEND="
	>=dev-perl/Module-Implementation-0.50.0
	>=dev-perl/Sub-Exporter-Progressive-0.1.6
	>=dev-perl/Variable-Magic-0.480.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-Text-ParseWords
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		virtual/perl-File-Spec
		virtual/perl-Module-Metadata
		>=virtual/perl-Test-Simple-0.890.0
	)
"
