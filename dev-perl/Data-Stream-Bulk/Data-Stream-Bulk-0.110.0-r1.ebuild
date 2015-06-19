# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Data-Stream-Bulk/Data-Stream-Bulk-0.110.0-r1.ebuild,v 1.1 2014/08/26 18:49:31 axs Exp $

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
