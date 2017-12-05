# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RJBS
DIST_VERSION=0.200006
inherit perl-module

DESCRIPTION="A thing that takes a string of Perl and rewrites its documentation"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Encode
	virtual/perl-Scalar-List-Utils
	dev-perl/Moose
	dev-perl/PPI
	dev-perl/Params-Util
	>=dev-perl/Pod-Elemental-0.103.0
	dev-perl/namespace-autoclean
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
	)
"
