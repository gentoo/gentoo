# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=6
DIST_AUTHOR=RJBS
DIST_VERSION=0.008
inherit perl-module

DESCRIPTION="a simple sprintf-like dialect"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# r: Scalar::Util -> Scalar-List-Utils
RDEPEND="
	virtual/perl-Carp
	dev-perl/Params-Util
	virtual/perl-Scalar-List-Utils
	>=dev-perl/String-Formatter-0.102.81
	dev-perl/Sub-Exporter
	virtual/perl-Time-Piece
	virtual/perl-parent
"
# t: Date::Format -> TimeDate
DEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/TimeDate
		virtual/perl-File-Spec
		dev-perl/JSON-MaybeXS
		>=virtual/perl-Test-Simple-0.960.0
		virtual/perl-autodie
	)
"
