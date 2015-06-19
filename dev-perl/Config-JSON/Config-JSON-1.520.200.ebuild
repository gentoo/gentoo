# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Config-JSON/Config-JSON-1.520.200.ebuild,v 1.1 2015/04/05 22:45:34 dilfridge Exp $

EAPI=5
MODULE_AUTHOR=RIZEN
MODULE_VERSION=1.5202
inherit perl-module

DESCRIPTION="A JSON based config file system"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=virtual/perl-File-Temp-0.180.0
	>=dev-perl/JSON-2.160.0
	>=virtual/perl-Scalar-List-Utils-1.190.0
	dev-perl/Moo
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		>=virtual/perl-Test-Simple-0.700.0
		>=dev-perl/Test-Deep-0.95.0
	)
"

SRC_TEST="do"
