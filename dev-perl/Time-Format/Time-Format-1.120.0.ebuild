# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Time-Format/Time-Format-1.120.0.ebuild,v 1.2 2015/06/13 22:07:44 dilfridge Exp $

EAPI=5
MODULE_AUTHOR=ROODE
MODULE_VERSION=1.12
inherit perl-module

DESCRIPTION='Easy-to-use date/time formatting'
LICENSE="Time-Format"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="test"

RDEPEND="
	dev-perl/DateManip
	>=virtual/perl-Time-Local-1.70.0
"

DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.400.0
	test? ( >=virtual/perl-Test-Simple-0.400.0 )
"

#SRC_TEST="skip"
# tests fail with current Date::Manip
# https://rt.cpan.org/Public/Bug/Display.html?id=85001
