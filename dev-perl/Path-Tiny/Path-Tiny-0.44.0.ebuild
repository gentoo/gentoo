# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Path-Tiny/Path-Tiny-0.44.0.ebuild,v 1.2 2014/12/04 11:53:41 zlogene Exp $

EAPI=5

MODULE_AUTHOR=DAGOLDEN
MODULE_VERSION=0.044
inherit perl-module

DESCRIPTION="File path utility"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Unicode-UTF8-0.580.0
	>=virtual/perl-File-Path-2.70.0
	>=virtual/perl-File-Temp-0.180.0
	>=virtual/perl-File-Spec-3.400.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		dev-perl/Devel-Hide
		dev-perl/Test-Deep
		virtual/perl-File-Spec
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.960.0
	)
"

SRC_TEST=do
