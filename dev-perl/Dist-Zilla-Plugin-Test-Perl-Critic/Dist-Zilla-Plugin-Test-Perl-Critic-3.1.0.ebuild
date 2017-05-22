# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=3.001
inherit perl-module

DESCRIPTION="Tests to check your code against best practices"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Data-Section-0.4.0
	dev-perl/Dist-Zilla
	dev-perl/Moose
	dev-perl/Sub-Exporter-ForMethods
	dev-perl/Test-Perl-Critic
	dev-perl/namespace-autoclean
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.34.0
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		virtual/perl-File-Path
		virtual/perl-File-Spec
		virtual/perl-Module-Metadata
		virtual/perl-IO
		>=virtual/perl-Test-Simple-0.940.0
		virtual/perl-autodie
	)
"
