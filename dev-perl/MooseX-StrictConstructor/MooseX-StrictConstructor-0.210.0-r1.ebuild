# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DROLSKY
DIST_VERSION=0.21
inherit perl-module

DESCRIPTION="Make your object constructors blow up on unknown attributes"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	>=dev-perl/Moose-0.940.0
	dev-perl/namespace-autoclean
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		dev-perl/Test-Fatal
		dev-perl/Test-Needs
		>=virtual/perl-Test-Simple-0.960.0
	)
"
