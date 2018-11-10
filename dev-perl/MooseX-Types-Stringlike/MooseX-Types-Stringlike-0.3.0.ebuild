# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DAGOLDEN
DIST_VERSION=0.003

inherit perl-module

DESCRIPTION="Moose type constraints for strings or string-like objects"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/MooseX-Types
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? (
		virtual/perl-File-Spec
		virtual/perl-Scalar-List-Utils
		dev-perl/Moose
		virtual/perl-File-Temp
		>=virtual/perl-Test-Simple-0.960.0
		virtual/perl-version
	)
"
