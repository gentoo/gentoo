# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=6
DIST_AUTHOR=RJBS
DIST_VERSION=1.101245
inherit perl-module

DESCRIPTION="string munging for loggers"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# r: Scalar::Util -> Scalar-List-Utils
# r: Sub::Exporter::Util -> Sub-Exporter
# r: strict, warnings -> perl
RDEPEND="
	dev-perl/JSON-MaybeXS
	dev-perl/Params-Util
	virtual/perl-Scalar-List-Utils
	dev-perl/Sub-Exporter
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.960.0
	)
"
