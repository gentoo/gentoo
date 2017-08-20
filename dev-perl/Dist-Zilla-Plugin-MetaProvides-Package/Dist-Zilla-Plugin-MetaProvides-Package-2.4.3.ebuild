# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=KENTNL
DIST_VERSION=2.004003
inherit perl-module

DESCRIPTION="Extract namespaces/version from traditional packages for provides"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Data-Dump-1.160.0
	>=dev-perl/Dist-Zilla-5.0.0
	>=dev-perl/Dist-Zilla-Plugin-MetaProvides-1.150.0.0
	>=dev-perl/Dist-Zilla-Role-ModuleMetadata-0.4.0
	dev-perl/Moose
	dev-perl/MooseX-LazyRequire
	dev-perl/MooseX-Types
	dev-perl/PPI
	dev-perl/Safe-Isa
	dev-perl/namespace-autoclean
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		>=virtual/perl-Module-Metadata-1.0.22
		>=dev-perl/Path-Tiny-0.58.0
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.990.0
	)
"
