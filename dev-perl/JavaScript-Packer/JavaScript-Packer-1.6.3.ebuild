# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/JavaScript-Packer/JavaScript-Packer-1.6.3.ebuild,v 1.1 2014/12/07 13:58:38 dilfridge Exp $

EAPI=5
MODULE_AUTHOR=NEVESENIN
MODULE_VERSION=1.006003
inherit perl-module

DESCRIPTION="Perl version of Dean Edward's Packer.js"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Regexp-RegGrp-1.1.1_rc
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.560.0
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do"
