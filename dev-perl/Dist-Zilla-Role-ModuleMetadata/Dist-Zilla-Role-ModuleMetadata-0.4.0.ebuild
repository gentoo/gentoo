# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=0.004
inherit perl-module

DESCRIPTION="A role for plugins that use Module::Metadata"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Digest-MD5
	>=virtual/perl-Module-Metadata-1.0.22
	dev-perl/Moose
	dev-perl/namespace-autoclean
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.34.0
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		dev-perl/Dist-Zilla
		virtual/perl-File-Spec
		dev-perl/Path-Tiny
		virtual/perl-Scalar-List-Utils
		dev-perl/Test-Deep
		dev-perl/Test-Fatal
		dev-perl/Test-Needs
		>=virtual/perl-Test-Simple-0.880.0
		virtual/perl-if
	)
"
