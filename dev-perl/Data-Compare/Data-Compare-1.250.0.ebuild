# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Data-Compare/Data-Compare-1.250.0.ebuild,v 1.1 2015/04/05 22:50:32 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=DCANTRELL
MODULE_VERSION=1.25
inherit perl-module

DESCRIPTION="Compare perl data structures"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="test"

RDEPEND="
	>=dev-perl/File-Find-Rule-0.100.0
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Clone
		dev-perl/Scalar-Properties
		dev-perl/Test-Pod
	)
"

SRC_TEST="do"
