# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BBYRD
DIST_VERSION=0.92
inherit perl-module

DESCRIPTION="Plugin configuration containing settings for a Git repo"
LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	>=dev-perl/Dist-Zilla-1.0.0
	>=dev-perl/Moose-0.340.0
	>=dev-perl/MooseX-Types-0.60.0
	>=dev-perl/String-Errf-0.1.0
	>=dev-perl/namespace-clean-0.60.0
"
BDEPEND="${RDEPEND}
	test? (
		>=dev-perl/Test-CheckDeps-0.10.0
		>=virtual/perl-Test-Simple-0.940.0
	)
"
