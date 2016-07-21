# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=DOY
MODULE_VERSION=${PV:0:4}
inherit perl-module

DESCRIPTION="N at a time iteration API"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-perl/Moose
	dev-perl/Sub-Exporter
	dev-perl/Path-Class
	dev-perl/namespace-clean"
DEPEND=">=virtual/perl-ExtUtils-MakeMaker-6.31
	test? ( ${RDEPEND}
		dev-perl/Test-Requires
	)
"

SRC_TEST=do
