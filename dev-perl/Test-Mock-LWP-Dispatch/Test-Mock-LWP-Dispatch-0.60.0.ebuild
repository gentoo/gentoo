# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Mock-LWP-Dispatch/Test-Mock-LWP-Dispatch-0.60.0.ebuild,v 1.1 2015/05/19 22:48:12 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=TADAM
MODULE_VERSION=0.06
inherit perl-module

DESCRIPTION="Mocks LWP::UserAgent and dispatches your requests/responses"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	virtual/perl-Exporter
	dev-perl/libwww-perl
	dev-perl/Test-MockObject
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
"

SRC_TEST="do parallel"
