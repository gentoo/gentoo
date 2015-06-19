# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Any-Moose/Any-Moose-0.260.0.ebuild,v 1.3 2015/03/29 11:51:05 zlogene Exp $

EAPI=5

MODULE_AUTHOR=ETHER
MODULE_VERSION=0.26
inherit perl-module

DESCRIPTION="Use Moose or Mouse modules (DEPRECATED)"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE="test"

RDEPEND="|| ( >=dev-perl/Mouse-0.40 dev-perl/Moose )
	virtual/perl-version"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.31
	test? (
		dev-perl/MouseX-Types
		dev-perl/Moose
		dev-perl/MooseX-Types
	)
"
# see bug 543992 for the test dependencies

SRC_TEST=do
