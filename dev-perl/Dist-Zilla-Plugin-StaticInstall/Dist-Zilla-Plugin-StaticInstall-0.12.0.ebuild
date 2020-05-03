# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ETHER
DIST_VERSION=0.012
inherit perl-module

DESCRIPTION="Identify a distribution as eligible for static installation"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Dist-Zilla-4.300.39
	dev-perl/Moose
	dev-perl/MooseX-Types
	dev-perl/Path-Tiny
	>=virtual/perl-Scalar-List-Utils-1.330.0
	>=virtual/perl-Term-ANSIColor-3.0.0
	dev-perl/autovivification
	dev-perl/namespace-autoclean
"
DEPEND="
	dev-perl/Module-Build-Tiny
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.34.0
	test? (
		virtual/perl-File-Spec
		virtual/perl-Module-Metadata
		dev-perl/Module-Runtime
		dev-perl/Test-Deep
		dev-perl/Test-Fatal
		dev-perl/Test-Needs
		>=virtual/perl-Test-Simple-0.960.0
		virtual/perl-if
	)
"
