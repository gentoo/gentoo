# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Mouse/Mouse-2.4.1.ebuild,v 1.5 2015/06/13 22:28:28 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=GFUJI
inherit perl-module

DESCRIPTION="Moose minus the antlers"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE="test"

RDEPEND="
	>=virtual/perl-Scalar-List-Utils-1.140.0
	>=virtual/perl-XSLoader-0.20.0
"
# Test::Exception::LessClever -> Nowhere because upstream are wrong
DEPEND="
	>=virtual/perl-ExtUtils-ParseXS-3.220.0
	>=virtual/perl-Devel-PPPort-3.190.0
	>=dev-perl/Module-Build-0.400.500
	dev-perl/Module-Build-XSUtil
	${RDEPEND}
	test? (
		dev-perl/Test-Exception
		dev-perl/Test-Fatal
		dev-perl/Test-LeakTrace
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Test-Output
		dev-perl/Test-Requires
		dev-perl/Try-Tiny
	)
"
SRC_TEST="do parallel"
