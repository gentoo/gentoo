# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=CFAERBER
DIST_VERSION=2.300
inherit perl-module

DESCRIPTION="Internationalizing Domain Names in Applications (IDNA)"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

PERL_RM_FILES=(
	"t/10pod.t"
	"t/11pod_cover.t"
)
RDEPEND="
	virtual/perl-Unicode-Normalize
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-CBuilder
	>=dev-perl/Module-Build-0.420.0
	test? (
		virtual/perl-Test-Simple
		dev-perl/Test-NoWarnings
	)
"
