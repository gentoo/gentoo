# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Data-ICal/Data-ICal-0.220.0.ebuild,v 1.2 2015/05/03 10:48:14 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=ALEXMV
MODULE_VERSION=0.22
inherit perl-module

DESCRIPTION="Generates iCalendar (RFC 2445) calendar files"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/Class-Accessor
	dev-perl/Class-ReturnValue
	dev-perl/Text-vFile-asData
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
		dev-perl/Test-Warn
		dev-perl/Test-NoWarnings
		dev-perl/Test-LongString
		virtual/perl-Test-Simple
	)
"

SRC_TEST="do"

src_prepare() {
	sed -i "/^auto_install();/d" "${S}"/Makefile.PL || die
	perl-module_src_prepare
}
