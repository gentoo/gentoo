# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ETHER
MODULE_VERSION=0.27
inherit perl-module

DESCRIPTION="Helper functions for op tree manipulation"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE="test"

# needs Scalar::Util
RDEPEND="
	virtual/perl-Exporter
	virtual/perl-Scalar-List-Utils
	dev-perl/Task-Weaken
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-CBuilder
	>=dev-perl/ExtUtils-Depends-0.301.0
	test? (
		virtual/perl-Test-Simple
	)
"

SRC_TEST="do parallel"
