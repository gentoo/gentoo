# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=ILMARI
MODULE_VERSION=0.002
inherit perl-module

DESCRIPTION="Introspect overloaded operators"

SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE="test"

# Scalar::Util -> Scalar-List-Utils
RDEPEND="
	>=virtual/perl-Exporter-5.570.0
	dev-perl/MRO-Compat
	>=dev-perl/Package-Stash-0.140.0
	virtual/perl-Scalar-List-Utils
	dev-perl/Sub-Identify
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		>=virtual/perl-Test-Simple-0.880.0
		virtual/perl-parent
	)
"

SRC_TEST="do parallel"
