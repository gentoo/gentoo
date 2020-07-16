# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=0.012
inherit perl-module

DESCRIPTION="Path::Tiny types and coercions for Moose"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Moose-2.0.0
	dev-perl/MooseX-Getopt
	dev-perl/MooseX-Types
	dev-perl/MooseX-Types-Stringlike
	dev-perl/Path-Tiny
	virtual/perl-if
	dev-perl/namespace-autoclean
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.34.0
	test? (
		virtual/perl-File-Spec
		>=virtual/perl-File-Temp-0.180.0
		dev-perl/File-pushd
		virtual/perl-Module-Metadata
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.960.0
	)
"
mytargets="install"
