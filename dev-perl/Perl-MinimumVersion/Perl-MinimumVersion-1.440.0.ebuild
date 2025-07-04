# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DBOOK
DIST_VERSION=1.44
inherit perl-module

DESCRIPTION="Find a minimum required version of perl for Perl code"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/File-Find-Rule
	dev-perl/File-Find-Rule-Perl
	>=virtual/perl-Scalar-List-Utils-1.200.0
	>=dev-perl/PPI-1.252.0
	>=dev-perl/PPIx-Regexp-0.51.0
	dev-perl/PPIx-Utils
	>=dev-perl/Params-Util-0.250.0
	>=dev-perl/Perl-Critic-1.104.0
	>=virtual/perl-version-0.760.0
"
BDEPEND="
	${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-0.470.0
	)
"
